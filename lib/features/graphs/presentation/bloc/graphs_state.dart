part of 'graphs_bloc.dart';

abstract class GraphsState extends Equatable {
  const GraphsState();
}

class GraphsInitial extends GraphsState {
  @override
  List<Object> get props => [];
}

class GraphsSuccess extends GraphsState {
  final GraphData playsByDate;

  GraphsSuccess({
    @required this.playsByDate,
  });

  @override
  List<Object> get props => [playsByDate];
}

class GraphsFailure extends GraphsState {
  final Failure failure;
  final String message;
  final String suggestion;

  GraphsFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
