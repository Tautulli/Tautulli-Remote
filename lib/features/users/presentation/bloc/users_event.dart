part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class UsersFetched extends UsersEvent {
  final ServerModel server;
  final SettingsBloc settingsBloc;

  const UsersFetched({
    required this.server,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [server, settingsBloc];
}
