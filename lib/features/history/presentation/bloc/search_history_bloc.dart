import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/strings.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../history/domain/usecases/history.dart';
import '../../../image_url/domain/usecases/image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/history_model.dart';
import '../../../../core/helpers/history_bloc_helpers.dart';

part 'search_history_event.dart';
part 'search_history_state.dart';

String? searchStringCache;

const throttleDuration = Duration(milliseconds: 100);
const length = 25;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SearchHistoryBloc extends Bloc<SearchHistoryEvent, SearchHistoryState> {
  final History history;
  final ImageUrl imageUrl;
  final Logging logging;
  final SettingsBloc settingsBloc;

  SearchHistoryBloc({
    required this.history,
    required this.imageUrl,
    required this.logging,
    required this.settingsBloc,
  }) : super(const SearchHistoryState()) {
    on<SearchHistoryFetched>(
      _onSearchHistoryFetch,
      transformer: throttleDroppable(throttleDuration),
    );
    on<SearchHistoryClear>(_onSearchHistoryClear);
  }

  void _onSearchHistoryFetch(
    SearchHistoryFetched event,
    Emitter<SearchHistoryState> emit,
  ) async {
    if (isNotBlank(event.search)) {
      searchStringCache = event.search;
    }
    if (isBlank(searchStringCache)) return;

    if (event.freshFetch) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
          history: [],
          hasReachedMax: false,
        ),
      );
    }

    if (state.hasReachedMax) return;

    final List<String> mediaTypes = [];
    if (event.movieMediaType) mediaTypes.add('movie');
    if (event.episodeMediaType) mediaTypes.add('episode');
    if (event.trackMediaType) mediaTypes.add('track');
    if (event.liveMediaType) mediaTypes.add('live');

    final List<String> decisionTypes = [];
    if (event.directPlayDecision) decisionTypes.add('direct play');
    if (event.directStreamDecision) decisionTypes.add('copy');
    if (event.transcodeDecision) decisionTypes.add('transcode');

    if (state.status == BlocStatus.initial) {
      emit(
        state.copyWith(
          status: BlocStatus.inProgress,
        ),
      );

      final failureOrHistory = await history.getHistory(
        tautulliId: event.server.tautulliId,
        grouping: event.grouping,
        includeActivity: event.includeActivity,
        user: event.user,
        userId: event.userId == -1 ? null : event.userId,
        ratingKey: event.ratingKey,
        parentRatingKey: event.parentRatingKey,
        grandparentRatingKey: event.grandparentRatingKey,
        startDate: event.startDate,
        before: event.before,
        after: event.after,
        sectionId: event.sectionId,
        mediaType: mediaTypes.join(', '),
        transcodeDecision: decisionTypes.join(', '),
        guid: event.guid,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
        length: length,
        search: searchStringCache,
      );

      return _emitFailureOrHistory(
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
        userId: event.userId == -1 ? null : event.userId,
        ratingKey: event.ratingKey,
        parentRatingKey: event.parentRatingKey,
        grandparentRatingKey: event.grandparentRatingKey,
        startDate: event.startDate,
        before: event.before,
        after: event.after,
        sectionId: event.sectionId,
        mediaType: mediaTypes.join(', '),
        transcodeDecision: decisionTypes.join(', '),
        guid: event.guid,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
        start: state.history.length,
        length: length,
        search: searchStringCache,
      );

      return _emitFailureOrHistory(
        event: event,
        emit: emit,
        failureOrHistory: failureOrHistory,
      );
    }
  }

  void _emitFailureOrHistory({
    required SearchHistoryFetched event,
    required Emitter<SearchHistoryState> emit,
    required Either<Failure, Tuple2<List<HistoryModel>, bool>> failureOrHistory,
  }) async {
    await failureOrHistory.fold(
      (failure) async {
        logging.error('History :: Failed to fetch history [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            history: event.freshFetch ? [] : state.history,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (history) async {
        settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: history.value2,
          ),
        );

        // Add posters to history models
        List<HistoryModel> historyListWithUris = await historyModelsWithPosterUris(
          tautulliId: event.server.tautulliId,
          historyList: history.value1,
          imageUrl: imageUrl,
          settingsBloc: settingsBloc,
          logging: logging,
        );

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            history: state.history + historyListWithUris,
            hasReachedMax: historyListWithUris.length < length,
          ),
        );
      },
    );
  }

  void _onSearchHistoryClear(
    SearchHistoryClear event,
    Emitter<SearchHistoryState> emit,
  ) async {
    return emit(
      state.copyWith(
        status: BlocStatus.initial,
        history: [],
        hasReachedMax: false,
      ),
    );
  }
}
