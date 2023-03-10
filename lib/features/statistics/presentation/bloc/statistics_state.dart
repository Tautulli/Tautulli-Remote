part of 'statistics_bloc.dart';

class StatisticsState extends Equatable {
  final BlocStatus status;
  final List<StatisticModel> statList;
  final Map<StatIdType, bool> hasReachedMaxMap;
  final PlayMetricType statsType;
  final int timeRange;
  final Failure? failure;
  final String? message;
  final String? suggestion;

  const StatisticsState({
    this.status = BlocStatus.initial,
    this.statList = const [],
    this.hasReachedMaxMap = const {},
    this.statsType = PlayMetricType.plays,
    this.timeRange = 30,
    this.failure,
    this.message,
    this.suggestion,
  });

  StatisticsState copyWith({
    BlocStatus? status,
    List<StatisticModel>? statList,
    Map<StatIdType, bool>? hasReachedMaxMap,
    PlayMetricType? statsType,
    int? timeRange,
    Failure? failure,
    String? message,
    String? suggestion,
  }) {
    return StatisticsState(
      status: status ?? this.status,
      statList: statList ?? this.statList,
      hasReachedMaxMap: hasReachedMaxMap ?? this.hasReachedMaxMap,
      statsType: statsType ?? this.statsType,
      timeRange: timeRange ?? this.timeRange,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  List<Object> get props => [status, statList, hasReachedMaxMap, statsType, timeRange];
}
