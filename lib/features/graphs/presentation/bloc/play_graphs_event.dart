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

class PlayGraphsLoadPlaysByDateGraph extends PlayGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlayByDate;

  PlayGraphsLoadPlaysByDateGraph({
    @required this.tautulliId,
    @required this.failureOrPlayByDate,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlayByDate];
}

class PlayGraphsFilter extends PlayGraphsEvent {
  final String tautulliId;
  final int timeRange;
  final String yAxis;
  final int userId;
  final int grouping;

  PlayGraphsFilter({
    @required this.tautulliId,
    this.timeRange,
    this.yAxis,
    this.userId,
    this.grouping,
  });

  @override
  List<Object> get props => [
        tautulliId,
        timeRange,
        yAxis,
        userId,
        grouping,
      ];
}
