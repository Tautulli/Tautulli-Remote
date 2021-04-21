part of 'play_graphs_bloc.dart';

abstract class PlayGraphsEvent extends Equatable {
  const PlayGraphsEvent();
}

class PlayGraphsFetch extends PlayGraphsEvent {
  final String tautulliId;
  final int timeRange;
  final String yAxis;
  final int userId;
  final int grouping;
  final SettingsBloc settingsBloc;

  PlayGraphsFetch({
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

class PlayGraphsLoadPlaysByDate extends PlayGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByDate;
  final String yAxis;

  PlayGraphsLoadPlaysByDate({
    @required this.tautulliId,
    @required this.failureOrPlaysByDate,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByDate, yAxis];
}

class PlayGraphsLoadPlaysByDayOfWeek extends PlayGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByDayOfWeek;
  final String yAxis;

  PlayGraphsLoadPlaysByDayOfWeek({
    @required this.tautulliId,
    @required this.failureOrPlaysByDayOfWeek,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByDayOfWeek, yAxis];
}

class PlayGraphsLoadPlaysByHourOfDay extends PlayGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByHourOfDay;
  final String yAxis;

  PlayGraphsLoadPlaysByHourOfDay({
    @required this.tautulliId,
    @required this.failureOrPlaysByHourOfDay,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByHourOfDay, yAxis];
}

class PlayGraphsLoadPlaysByTop10Platforms extends PlayGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByTop10Platforms;
  final String yAxis;

  PlayGraphsLoadPlaysByTop10Platforms({
    @required this.tautulliId,
    @required this.failureOrPlaysByTop10Platforms,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByTop10Platforms, yAxis];
}

class PlayGraphsLoadPlaysByTop10Users extends PlayGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysByTop10Users;
  final String yAxis;

  PlayGraphsLoadPlaysByTop10Users({
    @required this.tautulliId,
    @required this.failureOrPlaysByTop10Users,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysByTop10Users, yAxis];
}
