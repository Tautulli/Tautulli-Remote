// @dart=2.9

part of 'users_list_bloc.dart';

abstract class UsersListState extends Equatable {
  const UsersListState();

  @override
  List<Object> get props => [];
}

class UsersListInitial extends UsersListState {}

class UsersListInProgress extends UsersListState {}

class UsersListSuccess extends UsersListState {
  final List<User> usersList;

  UsersListSuccess({@required this.usersList});

  @override
  List<Object> get props => [usersList];
}

class UsersListFailure extends UsersListState {}
