part of 'statistics_bloc.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();
}

class StatisticsFetch extends StatisticsEvent {
  final String tautulliId;
  final int grouping;
  final int timeRange;
  final String statsType;
  final int statsCount;

  StatisticsFetch({
    @required this.tautulliId,
    this.grouping,
    this.timeRange,
    this.statsType,
    this.statsCount,
  });

  @override
  List<Object> get props => [
        tautulliId,
        grouping,
        timeRange,
        statsType,
        statsCount,
      ];
}

class StatisticsFilter extends StatisticsEvent {
  final String tautulliId;
  final int grouping;
  final int timeRange;
  final String statsType;
  final int statsCount;

  StatisticsFilter({
    @required this.tautulliId,
    this.grouping,
    this.timeRange,
    this.statsType,
    this.statsCount,
  });

  @override
  List<Object> get props => [
        tautulliId,
        grouping,
        timeRange,
        statsType,
        statsCount,
      ];
}
