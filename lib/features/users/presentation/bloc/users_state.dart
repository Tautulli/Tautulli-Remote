// @dart=2.9

part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {
  final String orderColumn;
  final String orderDir;

  UsersInitial({this.orderColumn, this.orderDir});

  @override
  List<Object> get props => [orderColumn, orderDir];
}

class UsersSuccess extends UsersState {
  final List<UserTable> list;
  final bool hasReachedMax;

  UsersSuccess({
    @required this.list,
    @required this.hasReachedMax,
  });

  UsersSuccess copyWith({
    List<UserTable> list,
    bool hasReachedMax,
  }) {
    return UsersSuccess(
      list: list ?? this.list,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [list, hasReachedMax];
}

class UsersFailure extends UsersState {
  final Failure failure;
  final String message;
  final String suggestion;

  UsersFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
