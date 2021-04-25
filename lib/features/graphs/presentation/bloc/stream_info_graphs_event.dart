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

class StreamInfoGraphsLoadPlaysBySourceResolution
    extends StreamInfoGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysBySourceResolution;
  final String yAxis;

  StreamInfoGraphsLoadPlaysBySourceResolution({
    @required this.tautulliId,
    @required this.failureOrPlaysBySourceResolution,
    @required this.yAxis,
  });

  @override
  List<Object> get props =>
      [tautulliId, failureOrPlaysBySourceResolution, yAxis];
}

class StreamInfoGraphsLoadPlaysByStreamResolution
    extends StreamInfoGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByStreamResolution;
  final String yAxis;

  StreamInfoGraphsLoadPlaysByStreamResolution({
    @required this.tautulliId,
    @required this.failureOrPlaysByStreamResolution,
    @required this.yAxis,
  });

  @override
  List<Object> get props =>
      [tautulliId, failureOrPlaysByStreamResolution, yAxis];
}
