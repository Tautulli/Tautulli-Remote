import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/history.dart';
import '../../domain/usecases/get_history.dart';

part 'history_libraries_event.dart';
part 'history_libraries_state.dart';

Map<int, List<History>> _historyListCacheMap = {};
String _tautulliIdCache;

class HistoryLibrariesBloc
    extends Bloc<HistoryLibrariesEvent, HistoryLibrariesState> {
  final GetHistory getHistory;
  final GetImageUrl getImageUrl;
  final Logging logging;

  HistoryLibrariesBloc({
    @required this.getHistory,
    @required this.getImageUrl,
    @required this.logging,
  }) : super(HistoryLibrariesInitial());

  @override
  Stream<Transition<HistoryLibrariesEvent, HistoryLibrariesState>>
      transformEvents(
    Stream<HistoryLibrariesEvent> events,
    transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 25)),
      transitionFn,
    );
  }

  @override
  Stream<HistoryLibrariesState> mapEventToState(
    HistoryLibrariesEvent event,
  ) async* {
    final currentState = state;

    if (event is HistoryLibrariesFetch && !_hasReachedMax(currentState)) {
      if (currentState is HistoryLibrariesInitial) {
        yield HistoryLibrariesInProgress();

        yield* _fetchInitial(
          tautulliId: event.tautulliId,
          sectionId: event.sectionId,
          useCachedList: true,
          settingsBloc: event.settingsBloc,
        );
      }
      if (currentState is HistoryLibrariesSuccess) {
        yield* _fetchMore(
          currentState: currentState,
          tautulliId: event.tautulliId,
          sectionId: event.sectionId,
          start: event.start,
          settingsBloc: event.settingsBloc,
        );
      }

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<HistoryLibrariesState> _fetchInitial({
    @required String tautulliId,
    int grouping,
    String user,
    int userId,
    int ratingKey,
    int parentRatingKey,
    int grandparentRatingKey,
    String startDate,
    @required int sectionId,
    String mediaType,
    String transcodeDecision,
    String guid,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
    bool useCachedList = false,
    @required SettingsBloc settingsBloc,
  }) async* {
    if (useCachedList &&
        _historyListCacheMap.containsKey(sectionId) &&
        _tautulliIdCache == tautulliId) {
      yield HistoryLibrariesSuccess(
        list: _historyListCacheMap[sectionId],
        hasReachedMax: _historyListCacheMap[sectionId].length < 25,
      );
    } else {
      final failureOrHistory = await getHistory(
        tautulliId: tautulliId,
        grouping: grouping,
        user: user,
        userId: userId,
        ratingKey: ratingKey,
        parentRatingKey: parentRatingKey,
        grandparentRatingKey: grandparentRatingKey,
        startDate: startDate,
        sectionId: sectionId,
        mediaType: mediaType,
        transcodeDecision: transcodeDecision,
        guid: guid,
        orderColumn: orderColumn,
        orderDir: orderDir,
        start: start,
        length: length ?? 25,
        search: search,
        settingsBloc: settingsBloc,
      );

      yield* failureOrHistory.fold(
        (failure) async* {
          logging.error(
            'History: Failed to load history for Section ID $sectionId}',
          );

          yield HistoryLibrariesFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (list) async* {
          await _getImages(
            list: list,
            tautulliId: tautulliId,
            settingsBloc: settingsBloc,
          );

          _historyListCacheMap[sectionId] = list;

          yield HistoryLibrariesSuccess(
            list: list,
            hasReachedMax: list.length < 25,
          );
        },
      );
    }
  }

  Stream<HistoryLibrariesState> _fetchMore({
    @required HistoryLibrariesSuccess currentState,
    @required String tautulliId,
    int grouping,
    String user,
    int userId,
    int ratingKey,
    int parentRatingKey,
    int grandparentRatingKey,
    String startDate,
    @required int sectionId,
    String mediaType,
    String transcodeDecision,
    String guid,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
    @required SettingsBloc settingsBloc,
  }) async* {
    final failureOrHistory = await getHistory(
      tautulliId: tautulliId,
      grouping: grouping,
      user: user,
      userId: userId,
      ratingKey: ratingKey,
      parentRatingKey: parentRatingKey,
      grandparentRatingKey: grandparentRatingKey,
      startDate: startDate,
      sectionId: sectionId,
      mediaType: mediaType,
      transcodeDecision: transcodeDecision,
      guid: guid,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: currentState.list.length,
      length: length ?? 25,
      search: search,
      settingsBloc: settingsBloc,
    );

    yield* failureOrHistory.fold(
      (failure) async* {
        logging.error(
          'History: Failed to load history for Section ID $sectionId}',
        );

        yield HistoryLibrariesFailure(
          failure: failure,
          message: FailureMapperHelper.mapFailureToMessage(failure),
          suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
        );
      },
      (list) async* {
        if (list.isEmpty) {
          yield currentState.copyWith(hasReachedMax: true);
        } else {
          await _getImages(
            list: list,
            tautulliId: tautulliId,
            settingsBloc: settingsBloc,
          );

          _historyListCacheMap[sectionId] = currentState.list + list;

          yield HistoryLibrariesSuccess(
            list: currentState.list + list,
            hasReachedMax: list.length < 25,
          );
        }
      },
    );
  }

  Future<void> _getImages({
    @required List<History> list,
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    for (History historyItem in list) {
      //* Fetch and assign image URLs
      String posterImg;
      int posterRatingKey;
      String posterFallback;

      // Assign values for poster URL
      switch (historyItem.mediaType) {
        case ('movie'):
        case ('clip'):
          posterImg = historyItem.thumb;
          posterRatingKey = historyItem.ratingKey;
          posterFallback = 'poster';
          break;
        case ('episode'):
          posterImg = historyItem.thumb;
          posterRatingKey = historyItem.grandparentRatingKey;
          posterFallback = 'poster';
          break;
        case ('track'):
          posterImg = historyItem.thumb;
          posterRatingKey = historyItem.parentRatingKey;
          posterFallback = 'cover';
          break;
        default:
          posterRatingKey = historyItem.ratingKey;
      }

      // Attempt to get poster URL
      final failureOrPosterUrl = await getImageUrl(
        tautulliId: tautulliId,
        img: posterImg,
        ratingKey: posterRatingKey,
        fallback: posterFallback,
        settingsBloc: settingsBloc,
      );
      failureOrPosterUrl.fold(
        (failure) {
          logging.warning(
            'History: Failed to load poster for rating key $posterRatingKey',
          );
        },
        (url) {
          historyItem.posterUrl = url;
        },
      );
    }
  }
}

bool _hasReachedMax(HistoryLibrariesState state) =>
    state is HistoryLibrariesSuccess && state.hasReachedMax;

void clearCache() {
  _historyListCacheMap = {};
  _tautulliIdCache = null;
}
