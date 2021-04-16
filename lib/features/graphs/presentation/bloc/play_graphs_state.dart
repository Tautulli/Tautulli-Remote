part of 'play_graphs_bloc.dart';

abstract class PlayGraphsState extends Equatable {
  const PlayGraphsState();
}

class PlayGraphsInitial extends PlayGraphsState {
  final int timeRange;

  PlayGraphsInitial({this.timeRange});

  @override
  List<Object> get props => [timeRange];
}

class PlayGraphsLoaded extends PlayGraphsState {
  final GraphState playsByDate;

  PlayGraphsLoaded({
    @required this.playsByDate,
  });

  PlayGraphsLoaded copyWith({
    GraphState playsByDate,
  }) {
    return PlayGraphsLoaded(
      playsByDate: playsByDate ?? this.playsByDate,
    );
  }

  @override
  List<Object> get props => [playsByDate];
}
