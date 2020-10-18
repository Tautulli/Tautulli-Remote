part of 'statistics_bloc.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();
}

class StatisticsInitial extends StatisticsState {
  final int timeRange;

  StatisticsInitial({this.timeRange});

  @override
  List<Object> get props => [timeRange];
}

class StatisticsSuccess extends StatisticsState {
  final Map<String, List<Statistics>> map;
  final bool noStats;
  final Map<String, bool> hasReachedMaxMap;
  final DateTime lastUpdated;

  StatisticsSuccess({
    @required this.map,
    @required this.noStats,
    @required this.hasReachedMaxMap,
    @required this.lastUpdated,
  });

  StatisticsSuccess copyWith({
    Map<String, List<Statistics>> map,
    bool noStats,
    Map<String, bool> hasReachedMaxMap,
    DateTime lastUpdated,
  }) {
    return StatisticsSuccess(
      map: map ?? this.map,
      noStats: noStats ?? this.noStats,
      hasReachedMaxMap: hasReachedMaxMap ?? this.hasReachedMaxMap,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object> get props => [lastUpdated];
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
