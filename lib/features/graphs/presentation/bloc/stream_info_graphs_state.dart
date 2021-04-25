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

  StreamInfoGraphsLoaded({
    @required this.playsByStreamType,
    @required this.playsBySourceResolution,
  });

  StreamInfoGraphsLoaded copyWith({
    GraphState playsByStreamType,
    GraphState playsBySourceResolution,
  }) {
    return StreamInfoGraphsLoaded(
      playsByStreamType: playsByStreamType ?? this.playsByStreamType,
      playsBySourceResolution:
          playsBySourceResolution ?? this.playsBySourceResolution,
    );
  }

  @override
  List<Object> get props => [
        playsByStreamType,
        playsBySourceResolution,
      ];
}
