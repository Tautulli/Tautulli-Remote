// @dart=2.9

part of 'statistics_bloc.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();
}

class StatisticsFetch extends StatisticsEvent {
  final String tautulliId;
  final int grouping;
  final int timeRange;
  final String statsType;
  final int statsStart;
  final int statsCount;
  final String statId;
  final SettingsBloc settingsBloc;

  StatisticsFetch({
    @required this.tautulliId,
    this.grouping,
    this.timeRange,
    this.statsType,
    this.statsStart,
    this.statsCount,
    this.statId,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [
        tautulliId,
        grouping,
        timeRange,
        statsType,
        statsCount,
        settingsBloc,
      ];
}

class StatisticsFilter extends StatisticsEvent {
  final String tautulliId;
  final int grouping;
  final int timeRange;
  final String statsType;
  final int statsStart;
  final int statsCount;
  final String statId;

  StatisticsFilter({
    @required this.tautulliId,
    this.grouping,
    this.timeRange,
    this.statsType,
    this.statsStart,
    this.statsCount,
    this.statId,
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
