part of 'graphs_bloc.dart';

abstract class GraphsEvent extends Equatable {
  const GraphsEvent();

  @override
  List<Object> get props => [];
}

class GraphsFetched extends GraphsEvent {
  final ServerModel server;
  final PlayMetricType yAxis;
  final int timeRange;
  final int? userId;
  final bool? grouping;
  final bool freshFetch;
  final SettingsBloc settingsBloc;

  const GraphsFetched({
    required this.server,
    required this.yAxis,
    required this.timeRange,
    this.userId,
    this.grouping,
    this.freshFetch = false,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [
        server,
        yAxis,
        timeRange,
        freshFetch,
        settingsBloc,
      ];
}

class GraphsEmit extends GraphsEvent {
  final GraphType graphType;
  final Either<Failure, Tuple2<GraphDataModel, bool>> failureOrGraph;
  final ServerModel server;
  final SettingsBloc settingsBloc;

  const GraphsEmit({
    required this.graphType,
    required this.failureOrGraph,
    required this.server,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [
        graphType,
        failureOrGraph,
        server,
        settingsBloc,
      ];
}
