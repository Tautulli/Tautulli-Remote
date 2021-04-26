part of 'stream_type_graphs_bloc.dart';

abstract class StreamTypeGraphsState extends Equatable {
  const StreamTypeGraphsState();

  @override
  List<Object> get props => [];
}

class StreamTypeGraphsInitial extends StreamTypeGraphsState {
  final int timeRange;

  StreamTypeGraphsInitial({this.timeRange});

  @override
  List<Object> get props => [timeRange];
}

class StreamTypeGraphsLoaded extends StreamTypeGraphsState {
  final GraphState playsByStreamType;
  final GraphState playsBySourceResolution;
  final GraphState playsByStreamResolution;
  final GraphState streamTypeByTop10Platforms;
  final GraphState streamTypeByTop10Users;

  StreamTypeGraphsLoaded({
    @required this.playsByStreamType,
    @required this.playsBySourceResolution,
    @required this.playsByStreamResolution,
    @required this.streamTypeByTop10Platforms,
    @required this.streamTypeByTop10Users,
  });

  StreamTypeGraphsLoaded copyWith({
    GraphState playsByStreamType,
    GraphState playsBySourceResolution,
    GraphState playsByStreamResolution,
    GraphState streamTypeByTop10Platforms,
    GraphState streamTypeByTop10Users,
  }) {
    return StreamTypeGraphsLoaded(
      playsByStreamType: playsByStreamType ?? this.playsByStreamType,
      playsBySourceResolution:
          playsBySourceResolution ?? this.playsBySourceResolution,
      playsByStreamResolution:
          playsByStreamResolution ?? this.playsByStreamResolution,
      streamTypeByTop10Platforms:
          streamTypeByTop10Platforms ?? this.streamTypeByTop10Platforms,
      streamTypeByTop10Users:
          streamTypeByTop10Users ?? this.streamTypeByTop10Users,
    );
  }

  @override
  List<Object> get props => [
        playsByStreamType,
        playsBySourceResolution,
        playsByStreamResolution,
        streamTypeByTop10Platforms,
        streamTypeByTop10Users,
      ];
}
