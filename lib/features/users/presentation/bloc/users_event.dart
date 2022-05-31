part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class UsersFetched extends UsersEvent {
  final String tautulliId;
  final SettingsBloc settingsBloc;

  const UsersFetched({
    required this.tautulliId,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, settingsBloc];
}
