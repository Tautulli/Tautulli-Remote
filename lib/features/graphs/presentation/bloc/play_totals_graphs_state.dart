// @dart=2.9

part of 'play_totals_graphs_bloc.dart';

abstract class PlayTotalsGraphsState extends Equatable {
  const PlayTotalsGraphsState();

  @override
  List<Object> get props => [];
}

class PlayTotalsGraphsInitial extends PlayTotalsGraphsState {
  final int timeRange;

  PlayTotalsGraphsInitial({this.timeRange});

  @override
  List<Object> get props => [timeRange];
}

class PlayTotalsGraphsLoaded extends PlayTotalsGraphsState {
  final GraphState playsPerMonth;

  PlayTotalsGraphsLoaded({
    @required this.playsPerMonth,
  });

  PlayTotalsGraphsLoaded copyWith({
    GraphState playsPerMonth,
  }) {
    return PlayTotalsGraphsLoaded(
      playsPerMonth: playsPerMonth ?? this.playsPerMonth,
    );
  }

  @override
  List<Object> get props => [playsPerMonth];
}
