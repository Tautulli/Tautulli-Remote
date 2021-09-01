// @dart=2.9

part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserFetch extends UserEvent {
  final String tautulliId;
  final int userId;
  final SettingsBloc settingsBloc;

  UserFetch({
    @required this.tautulliId,
    @required this.userId,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, userId, settingsBloc];
}
