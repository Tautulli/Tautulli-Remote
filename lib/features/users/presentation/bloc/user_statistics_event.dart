part of 'user_statistics_bloc.dart';

abstract class UserStatisticsEvent extends Equatable {
  const UserStatisticsEvent();

  @override
  List<Object> get props => [];
}

class UserStatisticsFetch extends UserStatisticsEvent {
  final String tautulliId;
  final int userId;
  final SettingsBloc settingsBloc;

  UserStatisticsFetch({
    @required this.tautulliId,
    @required this.userId,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, userId, settingsBloc];
}
