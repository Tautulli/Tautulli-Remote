part of 'users_bloc.dart';

enum UsersStatus { initial, success, failure }

class UsersState extends Equatable {
  final UsersStatus status;
  final List<UserModel> users;
  final Failure? failure;
  final String? message;
  final String? suggestion;
  final bool hasReachedMax;

  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.failure,
    this.message,
    this.suggestion,
    this.hasReachedMax = false,
  });

  UsersState copyWith({
    UsersStatus? status,
    List<UserModel>? users,
    Failure? failure,
    String? message,
    String? suggestion,
    bool? hasReachedMax,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, users, hasReachedMax];
}
