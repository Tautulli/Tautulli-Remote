part of 'graphs_bloc.dart';

class GraphsState extends Equatable {
  final int? userId;
  final PlayMetricType yAxis;
  final int timeRange;
  final Map<GraphType, GraphModel> graphs;

  const GraphsState({
    this.userId,
    this.yAxis = PlayMetricType.plays,
    this.timeRange = 30,
    this.graphs = const {},
  });

  GraphsState copyWith({
    int? userId,
    PlayMetricType? yAxis,
    int? timeRange,
    Map<GraphType, GraphModel>? graphs,
  }) {
    return GraphsState(
      userId: userId ?? this.userId,
      yAxis: yAxis ?? this.yAxis,
      timeRange: timeRange ?? this.timeRange,
      graphs: graphs ?? this.graphs,
    );
  }

  @override
  List<Object> get props => [yAxis, timeRange, graphs];
}
