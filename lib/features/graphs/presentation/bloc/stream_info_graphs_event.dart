part of 'stream_info_graphs_bloc.dart';

abstract class StreamInfoGraphsEvent extends Equatable {
  const StreamInfoGraphsEvent();

  @override
  List<Object> get props => [];
}

class StreamInfoGraphsFetch extends StreamInfoGraphsEvent {
  final String tautulliId;
  final int timeRange;
  final String yAxis;
  final int userId;
  final int grouping;
  final SettingsBloc settingsBloc;

  StreamInfoGraphsFetch({
    @required this.tautulliId,
    this.timeRange,
    this.yAxis,
    this.userId,
    this.grouping,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [
        tautulliId,
        timeRange,
        yAxis,
        userId,
        grouping,
        settingsBloc,
      ];
}

class StreamInfoGraphsLoadPlaysByStreamType extends StreamInfoGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByStreamType;
  final String yAxis;

  StreamInfoGraphsLoadPlaysByStreamType({
    @required this.tautulliId,
    @required this.failureOrPlaysByStreamType,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByStreamType, yAxis];
}
