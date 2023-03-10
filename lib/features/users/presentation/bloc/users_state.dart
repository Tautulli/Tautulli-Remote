part of 'users_bloc.dart';

class UsersState extends Equatable {
  final BlocStatus status;
  final List<UserModel> users;
  final Failure? failure;
  final String? message;
  final String? suggestion;

  const UsersState({
    this.status = BlocStatus.initial,
    this.users = const [],
    this.failure,
    this.message,
    this.suggestion,
  });

  UsersState copyWith({
    BlocStatus? status,
    List<UserModel>? users,
    Failure? failure,
    String? message,
    String? suggestion,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  List<Object> get props => [status, users];
}
