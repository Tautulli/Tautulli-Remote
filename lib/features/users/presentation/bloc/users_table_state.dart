part of 'users_table_bloc.dart';

class UsersTableState extends Equatable {
  final BlocStatus status;
  final List<UserTableModel> users;
  final Failure? failure;
  final String? message;
  final String? suggestion;
  final bool hasReachedMax;

  const UsersTableState({
    this.status = BlocStatus.initial,
    this.users = const [],
    this.failure,
    this.message,
    this.suggestion,
    this.hasReachedMax = false,
  });

  UsersTableState copyWith({
    BlocStatus? status,
    List<UserTableModel>? users,
    Failure? failure,
    String? message,
    String? suggestion,
    bool? hasReachedMax,
  }) {
    return UsersTableState(
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
