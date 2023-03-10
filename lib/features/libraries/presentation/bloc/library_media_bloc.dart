import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/section_type.dart';
import '../../../image_url/domain/usecases/image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/library_media_info_model.dart';
import '../../domain/usecases/libraries.dart';

part 'library_media_event.dart';
part 'library_media_state.dart';

Map<String, List<LibraryMediaInfoModel>> libraryMediaInfoCache = {};
const length = 100000000000;

class LibraryMediaBloc extends Bloc<LibraryMediaEvent, LibraryMediaState> {
  final Libraries libraries;
  final ImageUrl imageUrl;
  final Logging logging;

  LibraryMediaBloc({
    required this.libraries,
    required this.imageUrl,
    required this.logging,
  }) : super(const LibraryMediaState()) {
    on<LibraryMediaFetched>(_onLibraryMediaFetched);
  }

  void _onLibraryMediaFetched(
    LibraryMediaFetched event,
    Emitter<LibraryMediaState> emit,
  ) async {
    if (event.refresh == false &&
        event.fullRefresh == false &&
        libraryMediaInfoCache.containsKey('${event.server.tautulliId}:${event.sectionId}')) {
      return emit(
        state.copyWith(
          status: BlocStatus.success,
          libraryItems: libraryMediaInfoCache['${event.server.tautulliId}:${event.sectionId}'],
        ),
      );
    }

    if (event.refresh == true || event.fullRefresh == true) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
        ),
      );
    }

    if (event.fullRefresh == true) {
      logging.info('Library Media :: Performing a library media full refresh for ${event.sectionId}');
    }

    final failureOrLibraryMedia = await libraries.getLibraryMediaInfo(
      tautulliId: event.server.tautulliId,
      sectionId: event.sectionId,
      ratingKey: event.ratingKey,
      sectionType: event.sectionType,
      orderColumn: event.orderColumn,
      orderDir: 'asc',
      start: event.start,
      length: length,
      search: event.search,
      refresh: event.fullRefresh,
    );

    await failureOrLibraryMedia.fold(
      (failure) async {
        logging.error('Library Media :: Failed to fetch library media for ${event.sectionId} [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (libraryMedia) async {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: libraryMedia.value2,
          ),
        );

        // Add posters to library table models
        List<LibraryMediaInfoModel> libraryListWithUris = await _libraryMediaInfoModelsWithPosterUris(
          libraryMediaList: libraryMedia.value1,
          tautulliId: event.server.tautulliId,
          settingsBloc: event.settingsBloc,
        );

        libraryMediaInfoCache['${event.server.tautulliId}:${event.sectionId}'] = libraryListWithUris;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            libraryItems: libraryMediaInfoCache['${event.server.tautulliId}:${event.sectionId}'],
          ),
        );
      },
    );
  }

  Future<List<LibraryMediaInfoModel>> _libraryMediaInfoModelsWithPosterUris({
    required List<LibraryMediaInfoModel> libraryMediaList,
    required String tautulliId,
    required SettingsBloc settingsBloc,
  }) async {
    List<LibraryMediaInfoModel> libraryMediaWithImages = [];

    for (LibraryMediaInfoModel libraryMedia in libraryMediaList) {
      Uri? posterUri;

      if (libraryMedia.thumb != null) {
        final failureOrIconUrl = await imageUrl.getImageUrl(
          tautulliId: tautulliId,
          img: libraryMedia.thumb,
        );

        await failureOrIconUrl.fold(
          (failure) async {
            logging.error(
              'Library Media :: Failed to fetch poster url for ${libraryMedia.ratingKey} [$failure]',
            );
          },
          (uri) async {
            settingsBloc.add(
              SettingsUpdatePrimaryActive(
                tautulliId: tautulliId,
                primaryActive: uri.value2,
              ),
            );

            posterUri = uri.value1;
          },
        );
      }

      libraryMediaWithImages.add(
        libraryMedia.copyWith(
          posterUri: posterUri,
        ),
      );
    }

    return libraryMediaWithImages;
  }
}
