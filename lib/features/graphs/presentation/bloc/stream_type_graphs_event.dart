// @dart=2.9

part of 'stream_type_graphs_bloc.dart';

abstract class StreamTypeGraphsEvent extends Equatable {
  const StreamTypeGraphsEvent();

  @override
  List<Object> get props => [];
}

class StreamTypeGraphsFetch extends StreamTypeGraphsEvent {
  final String tautulliId;
  final int timeRange;
  final String yAxis;
  final int userId;
  final int grouping;
  final SettingsBloc settingsBloc;

  StreamTypeGraphsFetch({
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

class StreamTypeGraphsLoadPlaysByStreamType extends StreamTypeGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByStreamType;
  final String yAxis;

  StreamTypeGraphsLoadPlaysByStreamType({
    @required this.tautulliId,
    @required this.failureOrPlaysByStreamType,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByStreamType, yAxis];
}

class StreamTypeGraphsLoadPlaysBySourceResolution
    extends StreamTypeGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysBySourceResolution;
  final String yAxis;

  StreamTypeGraphsLoadPlaysBySourceResolution({
    @required this.tautulliId,
    @required this.failureOrPlaysBySourceResolution,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [
        tautulliId,
        failureOrPlaysBySourceResolution,
        yAxis,
      ];
}

class StreamTypeGraphsLoadPlaysByStreamResolution
    extends StreamTypeGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByStreamResolution;
  final String yAxis;

  StreamTypeGraphsLoadPlaysByStreamResolution({
    @required this.tautulliId,
    @required this.failureOrPlaysByStreamResolution,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [
        tautulliId,
        failureOrPlaysByStreamResolution,
        yAxis,
      ];
}

class StreamTypeGraphsLoadStreamTypeByTop10Platforms
    extends StreamTypeGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrStreamTypeByTop10Platforms;
  final String yAxis;

  StreamTypeGraphsLoadStreamTypeByTop10Platforms({
    @required this.tautulliId,
    @required this.failureOrStreamTypeByTop10Platforms,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [
        tautulliId,
        failureOrStreamTypeByTop10Platforms,
        yAxis,
      ];
}

class StreamTypeGraphsLoadStreamTypeByTop10Users extends StreamTypeGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrStreamTypeByTop10Users;
  final String yAxis;

  StreamTypeGraphsLoadStreamTypeByTop10Users({
    @required this.tautulliId,
    @required this.failureOrStreamTypeByTop10Users,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [
        tautulliId,
        failureOrStreamTypeByTop10Users,
        yAxis,
      ];
}
