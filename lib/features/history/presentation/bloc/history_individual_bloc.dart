import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../users/domain/entities/user_table.dart';
import '../../../users/domain/usecases/get_users_table.dart';
import '../../domain/entities/history.dart';
import '../../domain/usecases/get_history.dart';

part 'history_individual_event.dart';
part 'history_individual_state.dart';

Map<int, List<History>> _historyListCacheMap = {};
List<UserTable> _userTableListCache = [];
bool _hasReachedMaxCache;
String _tautulliIdCache;

class HistoryIndividualBloc
    extends Bloc<HistoryIndividualEvent, HistoryIndividualState> {
  final GetHistory getHistory;
  final GetUsersTable getUsersTable;
  final Logging logging;

  HistoryIndividualBloc({
    @required this.getHistory,
    @required this.getUsersTable,
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
  }) async* {
    int cacheRatingKey = grandparentRatingKey ?? parentRatingKey ?? ratingKey;
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
      );

      Either<Failure, List<UserTable>> failureOrUsersTable;
      if (_userTableListCache.isEmpty) {
        failureOrUsersTable = await getUsersTable(
          tautulliId: tautulliId,
          length: 100,
        );
      }

      yield* failureOrHistory.fold(
        (failure) async* {
          logging.error(
            'History: Failed to load history for rating key ${grandparentRatingKey ?? parentRatingKey ?? ratingKey}',
          );

          yield HistoryIndividualFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (list) async* {
          int key = grandparentRatingKey ?? parentRatingKey ?? ratingKey;
          _historyListCacheMap[key] = list;
          _hasReachedMaxCache = list.length < 25;

          if (_userTableListCache.isEmpty) {
            yield* failureOrUsersTable.fold(
              (failure) => null,
              (userTableList) async* {
                _userTableListCache = userTableList;
                yield HistoryIndividualSuccess(
                  list: list,
                  hasReachedMax: list.length < 25,
                  userTableList: userTableList,
                );
              },
            );
          }
          yield HistoryIndividualSuccess(
            list: list,
            hasReachedMax: list.length < 25,
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
    );

    yield* failureOrHistory.fold(
      (failure) async* {
        logging.error(
          'History: Failed to load additional history for rating key ${grandparentRatingKey ?? parentRatingKey ?? ratingKey}',
        );

        yield HistoryIndividualFailure(
          failure: failure,
          message: FailureMapperHelper.mapFailureToMessage(failure),
          suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
        );
      },
      (list) async* {
        if (list.isEmpty) {
          _hasReachedMaxCache = true;

          yield currentState.copyWith(hasReachedMax: true);
        } else {
          int key = grandparentRatingKey ?? parentRatingKey ?? ratingKey;
          _historyListCacheMap[key] = currentState.list + list;
          _hasReachedMaxCache = list.length < 25;

          yield HistoryIndividualSuccess(
            list: currentState.list + list,
            hasReachedMax: list.length < 25,
            userTableList: _userTableListCache,
          );
        }
      },
    );
  }
}

bool _hasReachedMax(HistoryIndividualState state) =>
    state is HistoryIndividualSuccess && state.hasReachedMax;

void clearCache() {
  _historyListCacheMap = {};
  // _userTableListCache = [];
  _hasReachedMaxCache = null;
  _tautulliIdCache = null;
}
