import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../../users/domain/entities/user.dart';
import '../../../users/domain/usecases/get_user_names.dart';

part 'users_list_event.dart';
part 'users_list_state.dart';

List<User> _usersListCache;
String _tautulliIdCache;

class UsersListBloc extends Bloc<UsersListEvent, UsersListState> {
  final GetUserNames getUserNames;
  final Logging logging;

  UsersListBloc({
    @required this.getUserNames,
    @required this.logging,
  }) : super(UsersListInitial());

  @override
  Stream<UsersListState> mapEventToState(
    UsersListEvent event,
  ) async* {
    if (event is UsersListFetch) {
      yield* _mapUsersListFetchToState(tautulliId: event.tautulliId);

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<UsersListState> _mapUsersListFetchToState({
    @required String tautulliId,
  }) async* {
    if (_usersListCache != null && tautulliId == _tautulliIdCache) {
      yield UsersListSuccess(usersList: _usersListCache);
    } else {
      yield UsersListInProgress();

      final userNamesOrFailure = await getUserNames(tautulliId: tautulliId);

      yield* userNamesOrFailure.fold(
        (failure) async* {
          logging.error(
            'History: Failed to load list of users',
          );

          yield UsersListFailure();
        },
        (userList) async* {
          User allUsers = User(friendlyName: 'All Users', userId: -1);

          _usersListCache = userList
            ..sort((a, b) => a.friendlyName
                .toLowerCase()
                .compareTo(b.friendlyName.toLowerCase()))
            ..insert(0, allUsers);

          yield UsersListSuccess(usersList: _usersListCache);
        },
      );
    }
  }
}

void clearCache() {
  _usersListCache = null;
}
