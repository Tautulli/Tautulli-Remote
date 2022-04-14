part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {
  final List<UserModel> users;

  const UsersInitial({
    required this.users,
  });

  @override
  List<Object> get props => [users];
}

class UsersSuccess extends UsersState {
  final bool loading;
  final List<UserModel> users;

  const UsersSuccess({
    required this.loading,
    required this.users,
  });

  UsersSuccess copyWith({
    bool? loading,
    List<UserModel>? users,
  }) {
    return UsersSuccess(
      loading: loading ?? this.loading,
      users: users ?? this.users,
    );
  }

  @override
  List<Object> get props => [loading, users];
}

class UsersFailure extends UsersState {
  final bool loading;
  final Failure failure;
  final String message;
  final String suggestion;

  const UsersFailure({
    required this.loading,
    required this.failure,
    required this.message,
    required this.suggestion,
  });

  UsersFailure copyWith({
    bool? loading,
    Failure? failure,
    String? message,
    String? suggestion,
  }) {
    return UsersFailure(
      loading: loading ?? this.loading,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  List<Object> get props => [loading, failure, message, suggestion];
}
