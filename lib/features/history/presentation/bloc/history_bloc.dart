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

part 'history_event.dart';
part 'history_state.dart';

List<History> _historyListCache;
int _userIdCache;
String _mediaTypeCache;
String _tautulliIdCache;
SettingsBloc _settingsBlocCache;

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistory getHistory;
  final GetImageUrl getImageUrl;
  final Logging logging;

  HistoryBloc({
    @required this.getHistory,
    @required this.getImageUrl,
    @required this.logging,
  }) : super(HistoryInitial(
          userId: _userIdCache,
          mediaType: _mediaTypeCache,
          tautulliId: _tautulliIdCache,
        ));

  @override
  Stream<Transition<HistoryEvent, HistoryState>> transformEvents(
    Stream<HistoryEvent> events,
    transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 25)),
      transitionFn,
    );
  }

  @override
  Stream<HistoryState> mapEventToState(
    HistoryEvent event,
  ) async* {
    final currentState = state;

    if (event is HistoryFetch && !_hasReachedMax(currentState)) {
      _userIdCache = event.userId;
      _mediaTypeCache = event.mediaType;

      if (currentState is HistoryInitial) {
        _settingsBlocCache = event.settingsBloc;

        yield* _fetchInitial(
          tautulliId: event.tautulliId,
          userId: event.userId,
          mediaType: event.mediaType,
          useCachedList: true,
          settingsBloc: _settingsBlocCache,
        );
      }
      if (currentState is HistorySuccess) {
        yield* _fetchMore(
          currentState: currentState,
          tautulliId: event.tautulliId,
          userId: event.userId,
          mediaType: event.mediaType,
          start: event.start,
          settingsBloc: _settingsBlocCache,
        );
      }

      _tautulliIdCache = event.tautulliId;
    }
    if (event is HistoryFilter) {
      yield HistoryInitial();
      _userIdCache = event.userId;
      _mediaTypeCache = event.mediaType;

      yield* _fetchInitial(
        tautulliId: event.tautulliId,
        userId: event.userId,
        mediaType: event.mediaType,
        settingsBloc: _settingsBlocCache,
      );

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<HistoryState> _fetchInitial({
    @required String tautulliId,
    int grouping,
    String user,
    int userId,
    int ratingKey,
    int parentRatingKey,
    int grandparentRatingKey,
    String startDate,
    int sectionId,
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
        _historyListCache != null &&
        _tautulliIdCache == tautulliId) {
      yield HistorySuccess(
        list: _historyListCache,
        hasReachedMax: false,
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
            'History: Failed to load history',
          );

          yield HistoryFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (list) async* {
          List<History> updatedList = await _getImages(
            list: list,
            tautulliId: tautulliId,
            settingsBloc: settingsBloc,
          );

          _historyListCache = updatedList;

          yield HistorySuccess(
            list: updatedList,
            hasReachedMax: updatedList.length < 25,
          );
        },
      );
    }
  }

  Stream<HistoryState> _fetchMore({
    @required HistorySuccess currentState,
    @required String tautulliId,
    int grouping,
    String user,
    int userId,
    int ratingKey,
    int parentRatingKey,
    int grandparentRatingKey,
    String startDate,
    int sectionId,
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
          'History: Failed to load additional history',
        );

        yield HistoryFailure(
          failure: failure,
          message: FailureMapperHelper.mapFailureToMessage(failure),
          suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
        );
      },
      (list) async* {
        if (list.isEmpty) {
          yield currentState.copyWith(hasReachedMax: true);
        } else {
          List<History> updatedList = await _getImages(
            list: list,
            tautulliId: tautulliId,
            settingsBloc: settingsBloc,
          );

          _historyListCache = currentState.list + list;

          yield HistorySuccess(
            list: currentState.list + updatedList,
            hasReachedMax: updatedList.length < 25,
          );
        }
      },
    );
  }

  Future<List<History>> _getImages({
    @required List<History> list,
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    List<History> newList = [];

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
          newList.add(historyItem.copyWith(posterUrl: url));
        },
      );
    }

    return newList;
  }
}

bool _hasReachedMax(HistoryState state) =>
    state is HistorySuccess && state.hasReachedMax;

void clearCache() {
  _historyListCache = null;
  _userIdCache = null;
  _mediaTypeCache = null;
  _tautulliIdCache = null;
}
