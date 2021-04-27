part of 'play_totals_graphs_bloc.dart';

abstract class PlayTotalsGraphsEvent extends Equatable {
  const PlayTotalsGraphsEvent();

  @override
  List<Object> get props => [];
}

class PlayTotalsGraphsFetch extends PlayTotalsGraphsEvent {
  final String tautulliId;
  final int timeRange;
  final String yAxis;
  final int userId;
  final int grouping;
  final SettingsBloc settingsBloc;

  PlayTotalsGraphsFetch({
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

class PlayTotalsGraphsLoadPlaysPerMonth extends PlayTotalsGraphsEvent {
  final String tautulliId;
  final Either<Failure, GraphData> failureOrPlaysPerMonth;
  final String yAxis;

  PlayTotalsGraphsLoadPlaysPerMonth({
    @required this.tautulliId,
    @required this.failureOrPlaysPerMonth,
    @required this.yAxis,
  });

  @override
  List<Object> get props => [tautulliId, failureOrPlaysPerMonth, yAxis];
}
