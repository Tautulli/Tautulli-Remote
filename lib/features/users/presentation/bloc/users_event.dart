part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class UsersFetched extends UsersEvent {
  final ServerModel server;

  const UsersFetched({
    required this.server,
  });

  @override
  List<Object> get props => [server];
}
