import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import 'graph_data.dart';

enum GraphCurrentState {
  inProgress,
  failure,
  success,
}

enum GraphType {
  playsByDate,
  playsByDayOfWeek,
  playsByHourOfDay,
  playsBySourceResolution,
  playsByStreamResolution,
  playsByStreamType,
  playsByTop10Platforms,
  playsByTop10Users,
  streamTypeByTop10Platforms,
  streamTypeByTop10Users,
  playsPerMonth,
}

class GraphState extends Equatable {
  final GraphData graphData;
  final GraphCurrentState graphCurrentState;
  final GraphType graphType;
  final String yAxis;
  final Failure failure;
  final String failureMessage;
  final String failureSuggestion;

  GraphState({
    @required this.graphData,
    @required this.graphCurrentState,
    @required this.graphType,
    @required this.yAxis,
    this.failure,
    this.failureMessage,
    this.failureSuggestion,
  });

  GraphState copyWith({
    GraphData graphData,
    GraphCurrentState graphCurrentState,
    GraphType graphType,
    String yAxis,
    Failure failure,
    String failureMessage,
    String failureSuggestion,
  }) {
    return GraphState(
      graphData: graphData ?? this.graphData,
      graphCurrentState: graphCurrentState ?? this.graphCurrentState,
      graphType: graphType ?? this.graphType,
      yAxis: yAxis ?? this.yAxis,
      failure: failure ?? this.failure,
      failureMessage: failureMessage ?? this.failureMessage,
      failureSuggestion: failureSuggestion ?? this.failureSuggestion,
    );
  }

  @override
  List<Object> get props => [
        graphData,
        graphCurrentState,
        graphType,
        yAxis,
        failure,
        failureMessage,
        failureSuggestion,
      ];
}
