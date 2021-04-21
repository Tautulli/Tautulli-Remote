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
  final GraphState playsByHourOfDay;

  PlayGraphsLoaded({
    @required this.playsByDate,
    @required this.playsByDayOfWeek,
    @required this.playsByHourOfDay,
  });

  PlayGraphsLoaded copyWith({
    GraphState playsByDate,
    GraphState playsByDayOfWeek,
    GraphState playsByHourOfDay,
  }) {
    return PlayGraphsLoaded(
      playsByDate: playsByDate ?? this.playsByDate,
      playsByDayOfWeek: playsByDayOfWeek ?? this.playsByDayOfWeek,
      playsByHourOfDay: playsByHourOfDay ?? this.playsByHourOfDay,
    );
  }

  @override
  List<Object> get props => [playsByDate, playsByDayOfWeek, playsByHourOfDay];
}
