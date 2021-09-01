// @dart=2.9

part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserInProgress extends UserState {}

class UserSuccess extends UserState {
  final UserTable user;

  UserSuccess({@required this.user});

  @override
  List<Object> get props => [user];
}

class UserFailure extends UserState {
  final Failure failure;
  final String message;
  final String suggestion;

  UserFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
