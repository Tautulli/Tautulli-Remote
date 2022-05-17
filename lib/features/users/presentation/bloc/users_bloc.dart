import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/users.dart';

part 'users_event.dart';
part 'users_state.dart';

String? tautulliIdCache;
Map<String, List<UserModel>> usersCache = {};
bool hasReachedMaxCache = false;

const throttleDuration = Duration(milliseconds: 100);
const length = 25;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final Users users;
  final Logging logging;

  UsersBloc({
    required this.users,
    required this.logging,
  }) : super(
          UsersState(
            users: tautulliIdCache != null ? usersCache[tautulliIdCache]! : [],
            hasReachedMax: hasReachedMaxCache,
          ),
        ) {
    on<UsersFetched>(
      _onUsersFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onUsersFetched(
    UsersFetched event,
    Emitter<UsersState> emit,
  ) async {
    final bool serverChange = tautulliIdCache != event.tautulliId;

    if (!usersCache.containsKey(event.tautulliId)) {
      usersCache[event.tautulliId] = [];
    }

    if (event.freshFetch || (tautulliIdCache != null && serverChange)) {
      emit(
        state.copyWith(
          status: UsersStatus.initial,
          users: serverChange ? [] : null,
          hasReachedMax: false,
        ),
      );
      usersCache[event.tautulliId] = [];
      hasReachedMaxCache = false;
    }

    tautulliIdCache = event.tautulliId;

    if (state.hasReachedMax) return;

    if (state.status == UsersStatus.initial) {
      // Prevent triggering initial fetch when navigating back to Users page
      if (usersCache[event.tautulliId]!.isNotEmpty) {
        return emit(
          state.copyWith(
            status: UsersStatus.success,
          ),
        );
      }

      final failureOrUsers = await users.getUsers(
        tautulliId: event.tautulliId,
        orderDir: event.orderDir,
        orderColumn: event.orderColumn,
        length: length,
      );

      return _emitFailureOrUsers(
        event: event,
        emit: emit,
        failureOrUsers: failureOrUsers,
      );
    } else {
      // Make sure bottom loader loading indicator displays when
      // attempting to fetch
      emit(
        state.copyWith(status: UsersStatus.success),
      );

      final failureOrUsers = await users.getUsers(
        tautulliId: event.tautulliId,
        orderDir: event.orderDir,
        orderColumn: event.orderColumn,
        length: length,
        start: usersCache[event.tautulliId]!.length,
      );

      return _emitFailureOrUsers(
        event: event,
        emit: emit,
        failureOrUsers: failureOrUsers,
      );
    }
  }

  void _emitFailureOrUsers({
    required UsersFetched event,
    required Emitter<UsersState> emit,
    required Either<Failure, Tuple2<List<UserModel>, bool>> failureOrUsers,
  }) {
    failureOrUsers.fold(
      (failure) {
        logging.error('Users :: Failed to fetch users [$failure]');

        return emit(
          state.copyWith(
            status: UsersStatus.failure,
            users:
                event.freshFetch ? usersCache[event.tautulliId] : state.users,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (users) {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.tautulliId,
            primaryActive: users.value2,
          ),
        );

        usersCache[event.tautulliId] =
            usersCache[event.tautulliId]! + users.value1;
        hasReachedMaxCache = users.value1.length < 10;

        return emit(
          state.copyWith(
            status: UsersStatus.success,
            users: usersCache[event.tautulliId],
            hasReachedMax: hasReachedMaxCache,
          ),
        );
      },
    );
  }
}
