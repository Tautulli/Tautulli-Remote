part of 'stream_info_graphs_bloc.dart';

abstract class StreamInfoGraphsState extends Equatable {
  const StreamInfoGraphsState();

  @override
  List<Object> get props => [];
}

class StreamInfoGraphsInitial extends StreamInfoGraphsState {
  final int timeRange;

  StreamInfoGraphsInitial({this.timeRange});

  @override
  List<Object> get props => [timeRange];
}

class StreamInfoGraphsLoaded extends StreamInfoGraphsState {
  final GraphState playsByStreamType;
  final GraphState playsBySourceResolution;
  final GraphState playsByStreamResolution;
  final GraphState streamTypeByTop10Platforms;

  StreamInfoGraphsLoaded({
    @required this.playsByStreamType,
    @required this.playsBySourceResolution,
    @required this.playsByStreamResolution,
    @required this.streamTypeByTop10Platforms,
  });

  StreamInfoGraphsLoaded copyWith({
    GraphState playsByStreamType,
    GraphState playsBySourceResolution,
    GraphState playsByStreamResolution,
    GraphState streamTypeByTop10Platforms,
  }) {
    return StreamInfoGraphsLoaded(
      playsByStreamType: playsByStreamType ?? this.playsByStreamType,
      playsBySourceResolution:
          playsBySourceResolution ?? this.playsBySourceResolution,
      playsByStreamResolution:
          playsByStreamResolution ?? this.playsByStreamResolution,
      streamTypeByTop10Platforms:
          streamTypeByTop10Platforms ?? this.streamTypeByTop10Platforms,
    );
  }

  @override
  List<Object> get props => [
        playsByStreamType,
        playsBySourceResolution,
        playsByStreamResolution,
        streamTypeByTop10Platforms,
      ];
}
