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

  StreamInfoGraphsLoaded({
    @required this.playsByStreamType,
  });

  StreamInfoGraphsLoaded copyWith({
    GraphState playsByStreamType,
  }) {
    return StreamInfoGraphsLoaded(
      playsByStreamType: playsByStreamType ?? this.playsByStreamType,
    );
  }

  @override
  List<Object> get props => [
        playsByStreamType,
      ];
}
