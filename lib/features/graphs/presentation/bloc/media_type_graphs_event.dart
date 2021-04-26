part of 'media_type_graphs_bloc.dart';

abstract class MediaTypeGraphsEvent extends Equatable {
  const MediaTypeGraphsEvent();
}

class MediaTypeGraphsFetch extends MediaTypeGraphsEvent {
  final String tautulliId;
  final int timeRange;
  final String yAxis;
  final int userId;
  final int grouping;
  final SettingsBloc settingsBloc;

  MediaTypeGraphsFetch({
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

class MediaTypeGraphsLoadPlaysByDate extends MediaTypeGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByDate;
  final String yAxis;

  MediaTypeGraphsLoadPlaysByDate({
    @required this.tautulliId,
    @required this.failureOrPlaysByDate,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByDate, yAxis];
}

class MediaTypeGraphsLoadPlaysByDayOfWeek extends MediaTypeGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByDayOfWeek;
  final String yAxis;

  MediaTypeGraphsLoadPlaysByDayOfWeek({
    @required this.tautulliId,
    @required this.failureOrPlaysByDayOfWeek,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByDayOfWeek, yAxis];
}

class MediaTypeGraphsLoadPlaysByHourOfDay extends MediaTypeGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByHourOfDay;
  final String yAxis;

  MediaTypeGraphsLoadPlaysByHourOfDay({
    @required this.tautulliId,
    @required this.failureOrPlaysByHourOfDay,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByHourOfDay, yAxis];
}

class MediaTypeGraphsLoadPlaysByTop10Platforms extends MediaTypeGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByTop10Platforms;
  final String yAxis;

  MediaTypeGraphsLoadPlaysByTop10Platforms({
    @required this.tautulliId,
    @required this.failureOrPlaysByTop10Platforms,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByTop10Platforms, yAxis];
}

class MediaTypeGraphsLoadPlaysByTop10Users extends MediaTypeGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByTop10Users;
  final String yAxis;

  MediaTypeGraphsLoadPlaysByTop10Users({
    @required this.tautulliId,
    @required this.failureOrPlaysByTop10Users,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByTop10Users, yAxis];
}
