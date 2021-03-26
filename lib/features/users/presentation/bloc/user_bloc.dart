import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/user_table.dart';
import '../../domain/usecases/get_user.dart';

part 'user_event.dart';
part 'user_state.dart';

Map<int, UserTable> _userCache = {};

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUser getUser;
  final Logging logging;

  UserBloc({
    @required this.getUser,
    @required this.logging,
  }) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserFetch) {
      if (_userCache.containsKey(event.userId)) {
        yield UserSuccess(user: _userCache[event.userId]);
      } else {
        yield UserInProgress();

        final failureOrUser = await getUser(
          tautulliId: event.tautulliId,
          userId: event.userId,
          settingsBloc: event.settingsBloc,
        );

        yield* failureOrUser.fold(
          (failure) async* {
            logging.error('User: Failed to load user data for ${event.userId}');
          },
          (user) async* {
            _userCache[event.userId] = user;

            yield UserSuccess(user: user);
          },
        );
      }
    }
  }
}

void clearCache() {
  _userCache = {};
}
