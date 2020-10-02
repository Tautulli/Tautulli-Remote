part of 'statistics_bloc.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();
}

class StatisticsInitial extends StatisticsState {
  final String statsType;
  final int timeRange;

  StatisticsInitial({this.statsType, this.timeRange});

  @override
  List<Object> get props => [statsType, timeRange];
}

class StatisticsSuccess extends StatisticsState {
  final Map<String, List<Statistics>> map;
  final bool noStats;

  StatisticsSuccess({
    @required this.map,
    @required this.noStats,
  });

  @override
  List<Object> get props => [map];
}

class StatisticsFailure extends StatisticsState {
  final Failure failure;
  final String message;
  final String suggestion;

  StatisticsFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
