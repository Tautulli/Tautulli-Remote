part of 'user_statistics_bloc.dart';

abstract class UserStatisticsEvent extends Equatable {
  const UserStatisticsEvent();

  @override
  List<Object> get props => [];
}

class UserStatisticsFetched extends UserStatisticsEvent {
  final String tautulliId;
  final int userId;
  final bool freshFetch;
  final SettingsBloc settingsBloc;

  const UserStatisticsFetched({
    required this.tautulliId,
    required this.userId,
    this.freshFetch = false,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, userId, freshFetch, settingsBloc];
}
