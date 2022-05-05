import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/users.dart';

part 'users_event.dart';
part 'users_state.dart';

List<UserModel> usersCache = [];
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
            users: usersCache,
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
    if (event.freshFetch) {
      emit(
        state.copyWith(
          status: UsersStatus.initial,
          hasReachedMax: false,
        ),
      );
      usersCache = [];
      hasReachedMaxCache = false;
    }

    if (state.hasReachedMax) return;

    if (state.status == UsersStatus.initial) {
      // Prevent triggering initial fetch when navigating back to Users page
      if (usersCache.isNotEmpty) {
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

      return _emitFailureOrUsers(emit, failureOrUsers);
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
        start: usersCache.length,
      );

      return _emitFailureOrUsers(emit, failureOrUsers);
    }
  }

  void _emitFailureOrUsers(
    Emitter<UsersState> emit,
    Either<Failure, Tuple2<List<UserModel>, bool>> failureOrUsers,
  ) {
    failureOrUsers.fold(
      (failure) {
        //TODO Log failure

        return emit(
          state.copyWith(
            status: UsersStatus.failure,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (users) {
        //TODO: Update primary active if value changed?

        usersCache = usersCache + users.value1;
        hasReachedMaxCache = users.value1.length < 10;

        return emit(
          state.copyWith(
            status: UsersStatus.success,
            users: usersCache,
            hasReachedMax: hasReachedMaxCache,
          ),
        );
      },
    );
  }
}
