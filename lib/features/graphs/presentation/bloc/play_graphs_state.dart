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
  final GraphState playsByDayOfWeek;

  PlayGraphsLoaded({
    @required this.playsByDate,
    @required this.playsByDayOfWeek,
  });

  PlayGraphsLoaded copyWith({
    GraphState playsByDate,
    GraphState playsByDayOfWeek,
  }) {
    return PlayGraphsLoaded(
      playsByDate: playsByDate ?? this.playsByDate,
      playsByDayOfWeek: playsByDayOfWeek ?? this.playsByDayOfWeek,
    );
  }

  @override
  List<Object> get props => [playsByDate, playsByDayOfWeek];
}
