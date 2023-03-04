import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../image_url/domain/usecases/image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/library_table_model.dart';
import '../../domain/usecases/libraries.dart';

part 'libraries_event.dart';
part 'libraries_state.dart';

String? tautulliIdCache;
String? orderColumnCache;
String? orderDirCache;
Map<String, List<LibraryTableModel>> librariesCache = {};
bool hasReachedMaxCache = false;

const throttleDuration = Duration(milliseconds: 100);
const length = 25;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class LibrariesBloc extends Bloc<LibrariesEvent, LibrariesState> {
  final Libraries libraries;
  final ImageUrl imageUrl;
  final Logging logging;

  LibrariesBloc({
    required this.libraries,
    required this.imageUrl,
    required this.logging,
  }) : super(
          LibrariesState(
            libraries: tautulliIdCache != null ? librariesCache[tautulliIdCache]! : [],
            orderColumn: orderColumnCache ?? 'section_name',
            orderDir: orderDirCache ?? 'asc',
            hasReachedMax: hasReachedMaxCache,
          ),
        ) {
    on<LibrariesFetched>(
      _onLibrariesFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  void _onLibrariesFetched(
    LibrariesFetched event,
    Emitter<LibrariesState> emit,
  ) async {
    if (event.server.id == null) {
      Failure failure = MissingServerFailure();

      return emit(
        state.copyWith(
          status: BlocStatus.failure,
          failure: failure,
          message: FailureHelper.mapFailureToMessage(failure),
          suggestion: FailureHelper.mapFailureToSuggestion(failure),
        ),
      );
    }

    final bool serverChange = tautulliIdCache != event.server.tautulliId;

    if (!librariesCache.containsKey(event.server.tautulliId)) {
      librariesCache[event.server.tautulliId] = [];
    }

    if (event.freshFetch || (tautulliIdCache != null && serverChange)) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
          libraries: serverChange ? [] : null,
          hasReachedMax: false,
        ),
      );
      librariesCache[event.server.tautulliId] = [];
      hasReachedMaxCache = false;
    }

    tautulliIdCache = event.server.tautulliId;
    orderColumnCache = event.orderColumn;
    orderDirCache = event.orderDir;

    if (state.hasReachedMax) return;

    if (state.status == BlocStatus.initial) {
      // Prevent triggering initial fetch when navigating back to History page
      if (librariesCache[event.server.tautulliId]!.isNotEmpty) {
        return emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      }

      final failureOrLibraries = await libraries.getLibrariesTable(
        tautulliId: event.server.tautulliId,
        grouping: event.grouping,
        length: length,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
        search: event.search,
        start: event.start,
      );

      return _emitFailureOrLibraries(
        event: event,
        emit: emit,
        failureOrLibraries: failureOrLibraries,
      );
    } else {
      // Make sure bottom loader loading indicator displays when
      // attempting to fetch
      emit(
        state.copyWith(status: BlocStatus.success),
      );

      final failureOrLibraries = await libraries.getLibrariesTable(
        tautulliId: event.server.tautulliId,
        grouping: event.grouping,
        length: length,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
        search: event.search,
        start: librariesCache[event.server.tautulliId]!.length,
      );

      return _emitFailureOrLibraries(
        event: event,
        emit: emit,
        failureOrLibraries: failureOrLibraries,
      );
    }
  }

  void _emitFailureOrLibraries({
    required LibrariesFetched event,
    required Emitter<LibrariesState> emit,
    required Either<Failure, Tuple2<List<LibraryTableModel>, bool>> failureOrLibraries,
  }) async {
    await failureOrLibraries.fold(
      (failure) async {
        logging.error('Libraries :: Failed to fetch history [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            libraries: event.freshFetch ? librariesCache[event.server.tautulliId] : state.libraries,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (libraries) async {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: libraries.value2,
          ),
        );

        // Add posters to library table models
        List<LibraryTableModel> libraryListWithUris = await _libraryTableModelsWithPosterUris(
          libraryList: libraries.value1,
          settingsBloc: event.settingsBloc,
        );

        librariesCache[event.server.tautulliId] = librariesCache[event.server.tautulliId]! + libraryListWithUris;
        hasReachedMaxCache = libraryListWithUris.length < length;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            libraries: librariesCache[event.server.tautulliId],
            hasReachedMax: hasReachedMaxCache,
          ),
        );
      },
    );
  }

  Future<List<LibraryTableModel>> _libraryTableModelsWithPosterUris({
    required List<LibraryTableModel> libraryList,
    required SettingsBloc settingsBloc,
  }) async {
    List<LibraryTableModel> libraryTablesWithImages = [];

    for (LibraryTableModel library in libraryList) {
      Uri? iconUri;
      Uri? backgroundUri;

      if (library.libraryThumb != null && library.libraryThumb!.startsWith('http')) {
        final failureOrIconUrl = await imageUrl.getImageUrl(
          tautulliId: tautulliIdCache!,
          img: library.libraryThumb,
        );

        await failureOrIconUrl.fold(
          (failure) async {
            logging.error(
              'Libraries :: Failed to fetch icon url for ${library.sectionName} [$failure]',
            );
          },
          (uri) async {
            settingsBloc.add(
              SettingsUpdatePrimaryActive(
                tautulliId: tautulliIdCache!,
                primaryActive: uri.value2,
              ),
            );

            iconUri = uri.value1;
          },
        );
      }

      final failureOrBackgroundUrl = await imageUrl.getImageUrl(
        tautulliId: tautulliIdCache!,
        img: library.thumb ?? library.libraryThumb,
      );

      await failureOrBackgroundUrl.fold(
        (failure) async {
          logging.error(
            'Libraries :: Failed to fetch background url for ${library.sectionName} [$failure]',
          );
        },
        (uri) async {
          settingsBloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: tautulliIdCache!,
              primaryActive: uri.value2,
            ),
          );

          backgroundUri = uri.value1;
        },
      );

      libraryTablesWithImages.add(
        library.copyWith(
          iconUri: iconUri,
          backgroundUri: backgroundUri,
        ),
      );
    }

    return libraryTablesWithImages;
  }
}
