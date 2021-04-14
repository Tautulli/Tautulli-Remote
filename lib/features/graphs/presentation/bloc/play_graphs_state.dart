part of 'play_graphs_bloc.dart';

abstract class PlayGraphsState extends Equatable {
  const PlayGraphsState();
}

class PlayGraphsInitial extends PlayGraphsState {
  @override
  List<Object> get props => [];
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
