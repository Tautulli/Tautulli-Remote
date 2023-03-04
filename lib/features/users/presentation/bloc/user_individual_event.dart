part of 'user_individual_bloc.dart';

abstract class UserIndividualEvent extends Equatable {
  const UserIndividualEvent();

  @override
  List<Object> get props => [];
}

class UserIndividualFetched extends UserIndividualEvent {
  final ServerModel server;
  final int userId;
  final SettingsBloc settingsBloc;

  const UserIndividualFetched({
    required this.server,
    required this.userId,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [server, userId, settingsBloc];
}
