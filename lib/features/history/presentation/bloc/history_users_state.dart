part of 'history_users_bloc.dart';

abstract class HistoryUsersState extends Equatable {
  const HistoryUsersState();

  @override
  List<Object> get props => [];
}

class HistoryUsersInitial extends HistoryUsersState {}

class HistoryUsersInProgress extends HistoryUsersState {}

class HistoryUsersSuccess extends HistoryUsersState {
  final List<User> usersList;

  HistoryUsersSuccess({@required this.usersList});

  @override
  List<Object> get props => [usersList];
}

class HistoryUsersFailure extends HistoryUsersState {}
