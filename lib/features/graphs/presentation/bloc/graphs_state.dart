part of 'graphs_bloc.dart';

class GraphsState extends Equatable {
  final GraphYAxis yAxis;
  final Map<GraphType, GraphModel> graphs;

  const GraphsState({
    this.yAxis = GraphYAxis.plays,
    this.graphs = const {},
  });

  GraphsState copyWith({
    GraphYAxis? yAxis,
    Map<GraphType, GraphModel>? graphs,
  }) {
    return GraphsState(
      yAxis: yAxis ?? this.yAxis,
      graphs: graphs ?? this.graphs,
    );
  }

  @override
  List<Object> get props => [yAxis, graphs];
}
