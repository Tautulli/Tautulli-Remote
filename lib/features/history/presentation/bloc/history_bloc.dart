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

part 'history_event.dart';
part 'history_state.dart';

String? tautulliIdCache;
int? userIdCache;
bool? movieMediaTypeCache;
bool? episodeMediaTypeCache;
bool? trackMediaTypeCache;
bool? liveMediaTypeCache;
bool? directPlayDecisionCache;
bool? directStreamDecisionCache;
bool? transcodeDecisionCache;
Map<String, List<HistoryModel>> historyCache = {};
bool hasReachedMaxCache = false;

const throttleDuration = Duration(milliseconds: 100);
const length = 25;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final History history;
  final ImageUrl imageUrl;
  final Logging logging;

  HistoryBloc({
    required this.history,
    required this.imageUrl,
    required this.logging,
  }) : super(
          HistoryState(
            history: tautulliIdCache != null ? historyCache[tautulliIdCache]! : [],
            userId: userIdCache,
            hasReachedMax: hasReachedMaxCache,
          ),
        ) {
    on<HistoryFetched>(
      _onHistoryFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onHistoryFetched(
    HistoryFetched event,
    Emitter<HistoryState> emit,
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

    if (!historyCache.containsKey(event.server.tautulliId)) {
      historyCache[event.server.tautulliId] = [];
    }

    if (event.freshFetch || (tautulliIdCache != null && serverChange)) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
          history: serverChange ? [] : null,
          hasReachedMax: false,
        ),
      );
      historyCache[event.server.tautulliId] = [];
      hasReachedMaxCache = false;
    }

    tautulliIdCache = event.server.tautulliId;
    userIdCache = event.userId;
    movieMediaTypeCache = event.movieMediaType;
    episodeMediaTypeCache = event.episodeMediaType;
    trackMediaTypeCache = event.trackMediaType;
    liveMediaTypeCache = event.liveMediaType;
    directPlayDecisionCache = event.directPlayDecision;
    directStreamDecisionCache = event.directStreamDecision;
    transcodeDecisionCache = event.transcodeDecision;

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
      // Prevent triggering initial fetch when navigating back to History page
      if (historyCache[event.server.tautulliId]!.isNotEmpty) {
        return emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      }

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
        search: event.search,
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
        start: historyCache[event.server.tautulliId]!.length,
        length: length,
        search: event.search,
      );

      return _emitFailureOrHistory(
        event: event,
        emit: emit,
        failureOrHistory: failureOrHistory,
      );
    }
  }

  void _emitFailureOrHistory({
    required HistoryFetched event,
    required Emitter<HistoryState> emit,
    required Either<Failure, Tuple2<List<HistoryModel>, bool>> failureOrHistory,
  }) async {
    await failureOrHistory.fold(
      (failure) async {
        logging.error('History :: Failed to fetch history [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            history: event.freshFetch ? historyCache[event.server.tautulliId] : state.history,
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
          historyList: history.value1,
          settingsBloc: event.settingsBloc,
        );

        historyCache[event.server.tautulliId] = historyCache[event.server.tautulliId]! + historyListWithUris;
        hasReachedMaxCache = historyListWithUris.length < length;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            history: historyCache[event.server.tautulliId],
            hasReachedMax: hasReachedMaxCache,
          ),
        );
      },
    );
  }

  Future<List<HistoryModel>> _historyModelsWithPosterUris({
    required List<HistoryModel> historyList,
    required SettingsBloc settingsBloc,
  }) async {
    List<HistoryModel> historyWithImages = [];

    for (HistoryModel history in historyList) {
      final failureOrImageUrl = await imageUrl.getImageUrl(
        tautulliId: tautulliIdCache!,
        img: history.thumb,
        ratingKey: history.ratingKey,
      );

      await failureOrImageUrl.fold(
        (failure) async {
          logging.error(
            'History :: Failed to fetch image url for ${history.id} [$failure]',
          );

          historyWithImages.add(history);
        },
        (imageUri) async {
          settingsBloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: tautulliIdCache!,
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
