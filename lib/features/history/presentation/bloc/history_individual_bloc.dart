// @dart=2.9

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/domain/entities/user_table.dart';
import '../../../users/domain/usecases/get_users_table.dart';
import '../../domain/entities/history.dart';
import '../../domain/usecases/get_history.dart';

part 'history_individual_event.dart';
part 'history_individual_state.dart';

Map<int, List<History>> _historyListCacheMap = {};
List<UserTable> _userTableListCache = [];
String _tautulliIdCache;

class HistoryIndividualBloc
    extends Bloc<HistoryIndividualEvent, HistoryIndividualState> {
  final GetHistory getHistory;
  final GetUsersTable getUsersTable;
  final GetImageUrl getImageUrl;
  final Logging logging;

  HistoryIndividualBloc({
    @required this.getHistory,
    @required this.getUsersTable,
    @required this.getImageUrl,
    @required this.logging,
  }) : super(HistoryIndividualInitial());

  @override
  Stream<Transition<HistoryIndividualEvent, HistoryIndividualState>>
      transformEvents(
    Stream<HistoryIndividualEvent> events,
    transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 25)),
      transitionFn,
    );
  }

  @override
  Stream<HistoryIndividualState> mapEventToState(
    HistoryIndividualEvent event,
  ) async* {
    final currentState = state;

    if (event is HistoryIndividualFetch && !_hasReachedMax(currentState)) {
      if (currentState is HistoryIndividualInitial) {
        yield HistoryIndividualInProgress();

        yield* _fetchInitial(
          tautulliId: event.tautulliId,
          userId: event.userId,
          mediaType: event.mediaType,
          ratingKey: event.ratingKey,
          parentRatingKey: event.parentRatingKey,
          grandparentRatingKey: event.grandparentRatingKey,
          useCachedList: true,
          getImages: event.getImages,
          settingsBloc: event.settingsBloc,
        );
      }
      if (currentState is HistoryIndividualSuccess) {
        yield* _fetchMore(
          currentState: currentState,
          tautulliId: event.tautulliId,
          userId: event.userId,
          mediaType: event.mediaType,
          ratingKey: event.ratingKey,
          parentRatingKey: event.parentRatingKey,
          grandparentRatingKey: event.grandparentRatingKey,
          start: event.start,
          getImages: event.getImages,
          settingsBloc: event.settingsBloc,
        );
      }

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<HistoryIndividualState> _fetchInitial({
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
    bool getImages = false,
    @required SettingsBloc settingsBloc,
  }) async* {
    int cacheRatingKey =
        grandparentRatingKey ?? parentRatingKey ?? ratingKey ?? userId;
    if (useCachedList &&
        _historyListCacheMap.containsKey(cacheRatingKey) &&
        _tautulliIdCache == tautulliId) {
      yield HistoryIndividualSuccess(
        list: _historyListCacheMap[cacheRatingKey],
        hasReachedMax: _historyListCacheMap[cacheRatingKey].length < 25,
        userTableList: _userTableListCache,
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

      Either<Failure, List<UserTable>> failureOrUsersTable;
      if (_userTableListCache.isEmpty) {
        failureOrUsersTable = await getUsersTable(
          tautulliId: tautulliId,
          length: 100,
          settingsBloc: settingsBloc,
        );
      }

      yield* failureOrHistory.fold(
        (failure) async* {
          logging.error(
            userId != null
                ? 'History: Failed to load history for user ID $userId'
                : 'History: Failed to load history for rating key ${grandparentRatingKey ?? parentRatingKey ?? ratingKey}',
          );

          yield HistoryIndividualFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (list) async* {
          List<History> updatedList;

          if (getImages) {
            updatedList = await _getImages(
              list: list,
              tautulliId: tautulliId,
              settingsBloc: settingsBloc,
            );
          } else {
            updatedList = list;
          }

          int key =
              grandparentRatingKey ?? parentRatingKey ?? ratingKey ?? userId;
          _historyListCacheMap[key] = updatedList;

          if (_userTableListCache.isEmpty) {
            yield* failureOrUsersTable.fold(
              (failure) => null,
              (userTableList) async* {
                _userTableListCache = userTableList;
                yield HistoryIndividualSuccess(
                  list: updatedList,
                  hasReachedMax: updatedList.length < 25,
                  userTableList: userTableList,
                );
              },
            );
          }
          yield HistoryIndividualSuccess(
            list: updatedList,
            hasReachedMax: updatedList.length < 25,
            userTableList: _userTableListCache,
          );
        },
      );
    }
  }

  Stream<HistoryIndividualState> _fetchMore({
    @required HistoryIndividualSuccess currentState,
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
    bool getImages = false,
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
          userId != null
              ? 'History: Failed to load history for user ID $userId'
              : 'History: Failed to load history for rating key ${grandparentRatingKey ?? parentRatingKey ?? ratingKey}',
        );

        yield HistoryIndividualFailure(
          failure: failure,
          message: FailureMapperHelper.mapFailureToMessage(failure),
          suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
        );
      },
      (list) async* {
        if (list.isEmpty) {
          yield currentState.copyWith(hasReachedMax: true);
        } else {
          List<History> updatedList;

          if (getImages) {
            updatedList = await _getImages(
              list: list,
              tautulliId: tautulliId,
              settingsBloc: settingsBloc,
            );
          } else {
            updatedList = list;
          }

          int key =
              grandparentRatingKey ?? parentRatingKey ?? ratingKey ?? userId;
          _historyListCacheMap[key] = currentState.list + updatedList;

          yield HistoryIndividualSuccess(
            list: currentState.list + updatedList,
            hasReachedMax: updatedList.length < 25,
            userTableList: _userTableListCache,
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
          posterRatingKey = historyItem.ratingKey;
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

bool _hasReachedMax(HistoryIndividualState state) =>
    state is HistoryIndividualSuccess && state.hasReachedMax;

void clearCache() {
  _historyListCacheMap = {};
  _tautulliIdCache = null;
}
