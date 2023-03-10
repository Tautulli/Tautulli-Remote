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
import '../../data/models/history_model.dart';
import '../../domain/usecases/history.dart';

part 'library_history_event.dart';
part 'library_history_state.dart';

Map<String, List<HistoryModel>> libraryHistoryCache = {};

const throttleDuration = Duration(milliseconds: 100);
const length = 25;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class LibraryHistoryBloc extends Bloc<LibraryHistoryEvent, LibraryHistoryState> {
  final History history;
  final ImageUrl imageUrl;
  final Logging logging;

  LibraryHistoryBloc({
    required this.history,
    required this.imageUrl,
    required this.logging,
  }) : super(const LibraryHistoryState()) {
    on<LibraryHistoryFetched>(
      _onLibraryHistoryFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  void _onLibraryHistoryFetched(
    LibraryHistoryFetched event,
    Emitter<LibraryHistoryState> emit,
  ) async {
    final cacheKey = '${event.server.tautulliId}:${event.sectionId}';

    if (!libraryHistoryCache.containsKey(cacheKey)) {
      libraryHistoryCache[cacheKey] = [];
    }

    if (event.freshFetch) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
          hasReachedMax: false,
        ),
      );
      libraryHistoryCache[cacheKey] = [];
    }

    if (state.hasReachedMax) return;

    if (state.status == BlocStatus.initial) {
      // Prevent triggering initial fetch when navigating back to History tab
      if (libraryHistoryCache[cacheKey]!.isNotEmpty) {
        return emit(
          state.copyWith(
            status: BlocStatus.success,
            history: libraryHistoryCache[cacheKey],
            hasReachedMax: libraryHistoryCache[cacheKey]!.length < length,
          ),
        );
      }

      final failureOrHistory = await history.getHistory(
        tautulliId: event.server.tautulliId,
        grouping: event.grouping,
        includeActivity: event.includeActivity,
        user: event.user,
        userId: event.userId,
        ratingKey: event.ratingKey,
        parentRatingKey: event.parentRatingKey,
        grandparentRatingKey: event.grandparentRatingKey,
        startDate: event.startDate,
        before: event.before,
        after: event.after,
        sectionId: event.sectionId,
        mediaType: event.mediaType,
        // transcodeDecision: event.transcodeDecision,
        guid: event.guid,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
        length: length,
        search: event.search,
      );

      return _emitFailureOrHistory(
        cacheKey: cacheKey,
        event: event,
        emit: emit,
        failureOrHistory: failureOrHistory,
      );
    } else {
      // Make sure bottom loader loading indicator displays when
      // attempting to fetch
      emit(
        state.copyWith(status: BlocStatus.success),
      );

      final failureOrHistory = await history.getHistory(
        tautulliId: event.server.tautulliId,
        grouping: event.grouping,
        includeActivity: event.includeActivity,
        user: event.user,
        userId: event.userId,
        ratingKey: event.ratingKey,
        parentRatingKey: event.parentRatingKey,
        grandparentRatingKey: event.grandparentRatingKey,
        startDate: event.startDate,
        before: event.before,
        after: event.after,
        sectionId: event.sectionId,
        mediaType: event.mediaType,
        // transcodeDecision: event.transcodeDecision,
        guid: event.guid,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
        start: libraryHistoryCache[cacheKey]!.length,
        length: length,
        search: event.search,
      );

      return _emitFailureOrHistory(
        cacheKey: cacheKey,
        event: event,
        emit: emit,
        failureOrHistory: failureOrHistory,
      );
    }
  }

  void _emitFailureOrHistory({
    required String cacheKey,
    required LibraryHistoryFetched event,
    required Emitter<LibraryHistoryState> emit,
    required Either<Failure, Tuple2<List<HistoryModel>, bool>> failureOrHistory,
  }) async {
    await failureOrHistory.fold(
      (failure) async {
        logging.error(
          'Libraries :: Failed to fetch history for Library ID ${event.sectionId} [$failure]',
        );

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            history: event.freshFetch ? libraryHistoryCache[cacheKey] : state.history,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (history) async {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: history.value2,
          ),
        );

        // Add posters to history models
        List<HistoryModel> historyListWithUris = await _historyModelsWithPosterUris(
          tautulliId: event.server.tautulliId,
          historyList: history.value1,
          settingsBloc: event.settingsBloc,
        );

        libraryHistoryCache[cacheKey] = libraryHistoryCache[cacheKey]! + historyListWithUris;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            history: libraryHistoryCache[cacheKey],
            hasReachedMax: historyListWithUris.length < length,
          ),
        );
      },
    );
  }

  Future<List<HistoryModel>> _historyModelsWithPosterUris({
    required String tautulliId,
    required List<HistoryModel> historyList,
    required SettingsBloc settingsBloc,
  }) async {
    List<HistoryModel> historyWithImages = [];

    for (HistoryModel history in historyList) {
      final failureOrImageUrl = await imageUrl.getImageUrl(
        tautulliId: tautulliId,
        img: history.thumb,
        ratingKey: history.ratingKey,
      );

      await failureOrImageUrl.fold(
        (failure) async {
          logging.error(
            'Libraries :: Failed to fetch history image url for ${history.id} [$failure]',
          );

          historyWithImages.add(history);
        },
        (imageUri) async {
          settingsBloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: tautulliId,
              primaryActive: imageUri.value2,
            ),
          );

          historyWithImages.add(
            history.copyWith(
              posterUri: imageUri.value1,
            ),
          );
        },
      );
    }

    return historyWithImages;
  }
}
