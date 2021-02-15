import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../../users/domain/entities/user.dart';
import '../../../users/domain/usecases/get_user_names.dart';

part 'history_users_event.dart';
part 'history_users_state.dart';

List<User> _usersListCache;
String _tautulliIdCache;

class HistoryUsersBloc extends Bloc<HistoryUsersEvent, HistoryUsersState> {
  final GetUserNames getUserNames;
  final Logging logging;

  HistoryUsersBloc({
    @required this.getUserNames,
    @required this.logging,
  }) : super(HistoryUsersInitial());

  @override
  Stream<HistoryUsersState> mapEventToState(
    HistoryUsersEvent event,
  ) async* {
    if (event is HistoryUsersFetch) {
      yield* _mapHistoryUsersFetchToState(tautulliId: event.tautulliId);

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<HistoryUsersState> _mapHistoryUsersFetchToState({
    @required String tautulliId,
  }) async* {
    if (_usersListCache != null && tautulliId == _tautulliIdCache) {
      yield HistoryUsersSuccess(usersList: _usersListCache);
    } else {
      yield HistoryUsersInProgress();

      final userNamesOrFailure = await getUserNames(tautulliId: tautulliId);

      yield* userNamesOrFailure.fold(
        (failure) async* {
          logging.error(
            'History: Failed to load list of users',
          );

          yield HistoryUsersFailure();
        },
        (userList) async* {
          User allUsers = User(friendlyName: 'All Users', userId: -1);

          _usersListCache = userList
            ..sort((a, b) => a.friendlyName
                .toLowerCase()
                .compareTo(b.friendlyName.toLowerCase()))
            ..insert(0, allUsers);

          yield HistoryUsersSuccess(usersList: _usersListCache);
        },
      );
    }
  }
}

void clearCache() {
  _usersListCache = null;
}
