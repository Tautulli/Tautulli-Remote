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

  StreamInfoGraphsLoaded({
    @required this.playsByStreamType,
    @required this.playsBySourceResolution,
    @required this.playsByStreamResolution,
  });

  StreamInfoGraphsLoaded copyWith({
    GraphState playsByStreamType,
    GraphState playsBySourceResolution,
    GraphState playsByStreamResolution,
  }) {
    return StreamInfoGraphsLoaded(
      playsByStreamType: playsByStreamType ?? this.playsByStreamType,
      playsBySourceResolution:
          playsBySourceResolution ?? this.playsBySourceResolution,
      playsByStreamResolution:
          playsByStreamResolution ?? this.playsByStreamResolution,
    );
  }

  @override
  List<Object> get props => [
        playsByStreamType,
        playsBySourceResolution,
        playsByStreamResolution,
      ];
}
