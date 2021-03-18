part of 'users_list_bloc.dart';

abstract class UsersListEvent extends Equatable {
  const UsersListEvent();

  @override
  List<Object> get props => [];
}

class UsersListFetch extends UsersListEvent {
  final String tautulliId;
  final SettingsBloc settingsBloc;

  UsersListFetch({
    @required this.tautulliId,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, settingsBloc];
}
