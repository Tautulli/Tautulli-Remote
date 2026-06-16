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

  const StatisticsFetched({
    required this.server,
    required this.timeRange,
    required this.statsType,
    this.freshFetch = false,
  });

  @override
  List<Object> get props => [server, timeRange, statsType, freshFetch];
}

class StatisticsFetchMore extends StatisticsEvent {
  final StatIdType statIdType;

  const StatisticsFetchMore({
    required this.statIdType,
  });

  @override
  List<Object> get props => [statIdType];
}
