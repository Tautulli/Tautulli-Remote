part of 'user_individual_bloc.dart';

abstract class UserIndividualEvent extends Equatable {
  const UserIndividualEvent();

  @override
  List<Object> get props => [];
}

class UserIndividualFetched extends UserIndividualEvent {
  final String tautulliId;
  final int userId;
  final SettingsBloc settingsBloc;

  const UserIndividualFetched({
    required this.tautulliId,
    required this.userId,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, userId, settingsBloc];
}
