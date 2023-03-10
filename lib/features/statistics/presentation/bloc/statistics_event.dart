part of 'statistics_bloc.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => [];
}

class StatisticsFetched extends StatisticsEvent {
  final ServerModel server;
  final int timeRange;
  final PlayMetricType statsType;
  final bool freshFetch;
  final SettingsBloc settingsBloc;

  const StatisticsFetched({
    required this.server,
    required this.timeRange,
    required this.statsType,
    this.freshFetch = false,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [server, timeRange, statsType, freshFetch, settingsBloc];
}

class StatisticsFetchMore extends StatisticsEvent {
  final StatIdType statIdType;
  final SettingsBloc settingsBloc;

  const StatisticsFetchMore({
    required this.statIdType,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [statIdType, settingsBloc];
}
