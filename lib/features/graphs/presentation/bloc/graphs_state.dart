part of 'graphs_bloc.dart';

class GraphsState extends Equatable {
  final GraphYAxis yAxis;
  final int timeRange;
  final Map<GraphType, GraphModel> graphs;

  const GraphsState({
    this.yAxis = GraphYAxis.plays,
    this.timeRange = 30,
    this.graphs = const {},
  });

  GraphsState copyWith({
    GraphYAxis? yAxis,
    int? timeRange,
    Map<GraphType, GraphModel>? graphs,
  }) {
    return GraphsState(
      yAxis: yAxis ?? this.yAxis,
      timeRange: timeRange ?? this.timeRange,
      graphs: graphs ?? this.graphs,
    );
  }

  @override
  List<Object> get props => [yAxis, timeRange, graphs];
}
