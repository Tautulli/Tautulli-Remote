import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import 'graph_data.dart';

enum GraphCurrentState {
  inProgress,
  failure,
  success,
}

class GraphState extends Equatable {
  final GraphData graphData;
  final GraphCurrentState graphCurrentState;
  final String yAxis;
  final Failure failure;
  final String failureMessage;
  final String failureSuggestion;

  GraphState({
    @required this.graphData,
    @required this.graphCurrentState,
    @required this.yAxis,
    this.failure,
    this.failureMessage,
    this.failureSuggestion,
  });

  GraphState copyWith({
    GraphData graphData,
    GraphCurrentState graphCurrentState,
    String yAxis,
    Failure failure,
    String failureMessage,
    String failureSuggestion,
  }) {
    return GraphState(
      graphData: graphData ?? this.graphData,
      graphCurrentState: graphCurrentState ?? this.graphCurrentState,
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
        yAxis,
        failure,
        failureMessage,
        failureSuggestion,
      ];
}
