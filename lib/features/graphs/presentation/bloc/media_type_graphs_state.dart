// @dart=2.9

part of 'media_type_graphs_bloc.dart';

abstract class MediaTypeGraphsState extends Equatable {
  const MediaTypeGraphsState();
}

class MediaTypeGraphsInitial extends MediaTypeGraphsState {
  final int timeRange;

  MediaTypeGraphsInitial({this.timeRange});

  @override
  List<Object> get props => [timeRange];
}

class MediaTypeGraphsLoaded extends MediaTypeGraphsState {
  final GraphState playsByDate;
  final GraphState playsByDayOfWeek;
  final GraphState playsByHourOfDay;
  final GraphState playsByTop10Platforms;
  final GraphState playsByTop10Users;

  MediaTypeGraphsLoaded({
    @required this.playsByDate,
    @required this.playsByDayOfWeek,
    @required this.playsByHourOfDay,
    @required this.playsByTop10Platforms,
    @required this.playsByTop10Users,
  });

  MediaTypeGraphsLoaded copyWith({
    GraphState playsByDate,
    GraphState playsByDayOfWeek,
    GraphState playsByHourOfDay,
    GraphState playsByTop10Platforms,
    GraphState playsByTop10Users,
  }) {
    return MediaTypeGraphsLoaded(
      playsByDate: playsByDate ?? this.playsByDate,
      playsByDayOfWeek: playsByDayOfWeek ?? this.playsByDayOfWeek,
      playsByHourOfDay: playsByHourOfDay ?? this.playsByHourOfDay,
      playsByTop10Platforms:
          playsByTop10Platforms ?? this.playsByTop10Platforms,
      playsByTop10Users: playsByTop10Users ?? this.playsByTop10Users,
    );
  }

  @override
  List<Object> get props => [
        playsByDate,
        playsByDayOfWeek,
        playsByHourOfDay,
        playsByTop10Platforms,
        playsByTop10Users,
      ];
}
