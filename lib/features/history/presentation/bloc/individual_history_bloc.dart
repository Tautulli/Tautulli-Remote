import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/media_type.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/history_model.dart';
import '../../domain/usecases/history.dart';

part 'individual_history_event.dart';
part 'individual_history_state.dart';

Map<String, List<HistoryModel>> individualHistoryCache = {};
Map<String, bool> hasReachedMaxCache = {};

const throttleDuration = Duration(milliseconds: 100);
const length = 25;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class IndividualHistoryBloc extends Bloc<IndividualHistoryEvent, IndividualHistoryState> {
  final History history;
  final Logging logging;

  IndividualHistoryBloc({
    required this.history,
    required this.logging,
  }) : super(const IndividualHistoryState()) {
    on<IndividualHistoryFetched>(
      _onIndividualHistoryFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  void _onIndividualHistoryFetched(
    IndividualHistoryFetched event,
    Emitter<IndividualHistoryState> emit,
  ) async {
    final cacheKey = '${event.server.tautulliId}:${event.ratingKey}';

    if (!individualHistoryCache.containsKey(cacheKey)) {
      individualHistoryCache[cacheKey] = [];
    }
    if (!hasReachedMaxCache.containsKey(cacheKey)) {
      hasReachedMaxCache[cacheKey] = false;
    }

    if (event.freshFetch) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
          hasReachedMax: false,
        ),
      );
      individualHistoryCache[cacheKey] = [];
    }

    if (state.status == BlocStatus.initial) {
      // Prevent triggering initial fetch when navigating back to History tab
      if (individualHistoryCache[cacheKey]!.isNotEmpty) {
        return emit(
          state.copyWith(
            status: BlocStatus.success,
            history: individualHistoryCache[cacheKey],
            hasReachedMax: hasReachedMaxCache[cacheKey],
          ),
        );
      }

      final failureOrHistory = await history.getHistory(
        tautulliId: event.server.tautulliId,
        grouping: event.grouping,
        includeActivity: event.includeActivity,
        user: event.user,
        userId: event.userId,
        ratingKey: [
          MediaType.movie,
          MediaType.otherVideo,
          MediaType.episode,
          MediaType.track,
        ].contains(event.mediaType)
            ? event.ratingKey
            : null,
        parentRatingKey: [
          MediaType.album,
          MediaType.season,
        ].contains(event.mediaType)
            ? event.ratingKey
            : event.parentRatingKey,
        grandparentRatingKey: [
          MediaType.artist,
          MediaType.show,
        ].contains(event.mediaType)
            ? event.ratingKey
            : event.grandparentRatingKey,
        startDate: event.startDate,
        before: event.before,
        after: event.after,
        sectionId: event.sectionId,
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
        ratingKey: [
          MediaType.movie,
          MediaType.otherVideo,
          MediaType.episode,
          MediaType.track,
        ].contains(event.mediaType)
            ? event.ratingKey
            : null,
        parentRatingKey: [
          MediaType.album,
          MediaType.season,
        ].contains(event.mediaType)
            ? event.ratingKey
            : event.parentRatingKey,
        grandparentRatingKey: [
          MediaType.artist,
          MediaType.show,
        ].contains(event.mediaType)
            ? event.ratingKey
            : event.grandparentRatingKey,
        startDate: event.startDate,
        before: event.before,
        after: event.after,
        sectionId: event.sectionId,
        // transcodeDecision: event.transcodeDecision,
        guid: event.guid,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
        start: individualHistoryCache[cacheKey]!.length,
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
    required IndividualHistoryFetched event,
    required Emitter<IndividualHistoryState> emit,
    required Either<Failure, Tuple2<List<HistoryModel>, bool>> failureOrHistory,
  }) async {
    await failureOrHistory.fold(
      (failure) async {
        logging.error(
          'History :: Failed to fetch individual history for ${event.ratingKey} [$failure]',
        );

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            history: event.freshFetch ? individualHistoryCache[cacheKey] : state.history,
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

        individualHistoryCache[cacheKey] = individualHistoryCache[cacheKey]! + history.value1;
        hasReachedMaxCache[cacheKey] = history.value1.length < length;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            history: individualHistoryCache[cacheKey],
            hasReachedMax: history.value1.length < length,
          ),
        );
      },
    );
  }
}
