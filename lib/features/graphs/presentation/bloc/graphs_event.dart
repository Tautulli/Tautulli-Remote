part of 'graphs_bloc.dart';

abstract class GraphsEvent extends Equatable {
  const GraphsEvent();

  @override
  List<Object> get props => [];
}

class GraphsFetched extends GraphsEvent {
  final String tautulliId;
  final GraphYAxis yAxis;
  final int? userId;
  final bool? grouping;
  final bool freshFetch;
  final SettingsBloc settingsBloc;

  const GraphsFetched({
    required this.tautulliId,
    required this.yAxis,
    this.userId,
    this.grouping,
    this.freshFetch = false,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, yAxis, freshFetch, settingsBloc];
}

class GraphsEmit extends GraphsEvent {
  final GraphType graphType;
  final Either<Failure, Tuple2<GraphDataModel, bool>> failureOrGraph;
  final String tautulliId;
  final SettingsBloc settingsBloc;

  const GraphsEmit({
    required this.graphType,
    required this.failureOrGraph,
    required this.tautulliId,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [
        graphType,
        failureOrGraph,
        tautulliId,
        settingsBloc,
      ];
}
