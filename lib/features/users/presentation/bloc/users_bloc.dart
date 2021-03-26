import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/user_table.dart';
import '../../domain/usecases/get_users_table.dart';
import 'user_bloc.dart' as userBloc;

part 'users_event.dart';
part 'users_state.dart';

List<UserTable> _userTableListCache;
String _orderColumnCache;
String _orderDirCache;
String _tautulliIdCache;
bool _hasReachedMaxCache;
SettingsBloc _settingsBlocCache;

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsersTable getUsersTable;
  final Logging logging;

  UsersBloc({
    @required this.getUsersTable,
    @required this.logging,
  }) : super(UsersInitial(
          orderColumn: _orderColumnCache,
          orderDir: _orderDirCache,
        ));

  @override
  Stream<Transition<UsersEvent, UsersState>> transformEvents(
    Stream<UsersEvent> events,
    transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 30)),
      transitionFn,
    );
  }

  @override
  Stream<UsersState> mapEventToState(
    UsersEvent event,
  ) async* {
    final currentState = state;

    if (event is UsersFetch && !_hasReachedMax(currentState)) {
      _orderColumnCache = event.orderColumn;
      _orderDirCache = event.orderDir;
      _settingsBlocCache = event.settingsBloc;

      if (currentState is UsersInitial) {
        yield* _fetchInitial(
          tautulliId: event.tautulliId,
          grouping: event.grouping,
          orderColumn: event.orderColumn,
          orderDir: event.orderDir,
          start: event.start,
          length: event.length,
          search: event.search,
          useCachedList: true,
          settingsBloc: _settingsBlocCache,
        );
      }
      if (currentState is UsersSuccess) {
        yield* _fetchMore(
          currentState: currentState,
          tautulliId: event.tautulliId,
          grouping: event.grouping,
          orderColumn: event.orderColumn,
          orderDir: event.orderDir,
          start: event.start,
          length: event.length,
          search: event.search,
          settingsBloc: _settingsBlocCache,
        );
      }

      _tautulliIdCache = event.tautulliId;
    }
    if (event is UsersFilter) {
      yield UsersInitial();
      _orderColumnCache = event.orderColumn;
      _orderDirCache = event.orderDir;

      yield* _fetchInitial(
        tautulliId: event.tautulliId,
        grouping: event.grouping,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
        start: event.start,
        length: event.length,
        search: event.search,
        settingsBloc: _settingsBlocCache,
      );

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<UsersState> _fetchInitial({
    @required String tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
    bool useCachedList = false,
    @required SettingsBloc settingsBloc,
  }) async* {
    if (useCachedList &&
        _userTableListCache != null &&
        _tautulliIdCache == tautulliId) {
      yield UsersSuccess(
        list: _userTableListCache,
        hasReachedMax: _hasReachedMaxCache,
      );
    } else {
      final failureOrUsersList = await getUsersTable(
        tautulliId: tautulliId,
        grouping: grouping,
        orderColumn: orderColumn,
        orderDir: orderDir,
        start: start,
        length: length ?? 25,
        search: search,
        settingsBloc: settingsBloc,
      );

      yield* failureOrUsersList.fold(
        (failure) async* {
          logging.error(
            'Users: Failed to fetch users',
          );

          yield UsersFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (list) async* {
          _userTableListCache = list;
          _hasReachedMaxCache = list.length < 25;

          yield UsersSuccess(
            list: list,
            hasReachedMax: list.length < 25,
          );

          list.forEach((user) {
            userBloc.userCache['$tautulliId-${user.userId}'] = user;
          });
        },
      );
    }
  }

  Stream<UsersState> _fetchMore({
    @required UsersSuccess currentState,
    @required String tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
    @required SettingsBloc settingsBloc,
  }) async* {
    final failureOrUsersList = await getUsersTable(
      tautulliId: tautulliId,
      grouping: grouping,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: currentState.list.length,
      length: length ?? 25,
      search: search,
      settingsBloc: settingsBloc,
    );

    yield* failureOrUsersList.fold(
      (failure) async* {
        logging.error(
          'Users: Failed to fetch additional users',
        );

        yield UsersFailure(
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
          _userTableListCache = currentState.list + list;
          _hasReachedMaxCache = list.length < 25;

          yield UsersSuccess(
            list: currentState.list + list,
            hasReachedMax: list.length < 25,
          );

          list.forEach((user) {
            userBloc.userCache['$tautulliId-${user.userId}'] = user;
          });
        }
      },
    );
  }
}

bool _hasReachedMax(UsersState state) =>
    state is UsersSuccess && state.hasReachedMax;

void clearCache() {
  _userTableListCache = null;
  _orderColumnCache = null;
  _orderDirCache = null;
  _tautulliIdCache = null;
  _hasReachedMaxCache = null;
}
