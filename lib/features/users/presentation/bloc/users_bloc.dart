import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/users.dart';

part 'users_event.dart';
part 'users_state.dart';

List<UserModel> usersCache = [];

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final Users users;

  UsersBloc({
    required this.users,
  }) : super(UsersInitial(users: usersCache)) {
    on<UsersFetch>((event, emit) => _onUsersFetch(event, emit));
  }

  void _onUsersFetch(
    UsersFetch event,
    Emitter<UsersState> emit,
  ) async {
    //* Used to indicate to the UI the page is loading
    final currentState = state;
    if (currentState is UsersSuccess) {
      emit(
        currentState.copyWith(loading: true),
      );
    } else if (currentState is UsersFailure) {
      emit(
        currentState.copyWith(loading: true),
      );
    }

    final failureOrUsers = await users.getUsers(tautulliId: event.tautulliId);

    failureOrUsers.fold(
      (failure) {
        emit(
          UsersFailure(
            loading: false,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (users) {
        //TODO: Update primary active if value changed?

        usersCache = users.value1;

        emit(
          UsersSuccess(
            loading: false,
            users: users.value1,
          ),
        );
      },
    );
  }
}
