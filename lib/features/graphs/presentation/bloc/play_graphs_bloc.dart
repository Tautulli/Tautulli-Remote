import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/graph_data.dart';
import '../../domain/entities/graph_state.dart';
import '../../domain/usecases/get_plays_by_date.dart';
import '../../domain/usecases/get_plays_by_day_of_week.dart';
import '../../domain/usecases/get_plays_by_hour_of_day.dart';

part 'play_graphs_event.dart';
part 'play_graphs_state.dart';

GraphData _playsByDateCache;
GraphData _playsByDayOfWeekCache;
GraphData _playsByHourOfDayCache;
String _yAxisCache;
int _timeRangeCache;

class PlayGraphsBloc extends Bloc<PlayGraphsEvent, PlayGraphsState> {
  final GetPlaysByDate getPlaysByDate;
  final GetPlaysByDayOfWeek getPlaysByDayOfWeek;
  final GetPlaysByHourOfDay getPlaysByHourOfDay;
  final Logging logging;

  PlayGraphsBloc({
    @required this.getPlaysByDate,
    @required this.getPlaysByDayOfWeek,
    @required this.getPlaysByHourOfDay,
    @required this.logging,
  }) : super(PlayGraphsInitial(
          timeRange: _timeRangeCache,
        ));
  @override
  Stream<PlayGraphsState> mapEventToState(
    PlayGraphsEvent event,
  ) async* {
    final currentState = state;

    if (event is PlayGraphsFetch) {
      _timeRangeCache = event.timeRange;

      GraphState playsByDateData = GraphState(
        graphData: _playsByDateCache,
        yAxis: _yAxisCache,
        graphCurrentState: GraphCurrentState.inProgress,
        graphType: GraphType.playsByDate,
      );

      GraphState playsByDayOfWeekData = GraphState(
        graphData: _playsByDayOfWeekCache,
        yAxis: _yAxisCache,
        graphCurrentState: GraphCurrentState.inProgress,
        graphType: GraphType.playsByDayOfWeek,
      );

      GraphState playsByHourOfDayData = GraphState(
        graphData: _playsByHourOfDayCache,
        yAxis: _yAxisCache,
        graphCurrentState: GraphCurrentState.inProgress,
        graphType: GraphType.playsByHourOfDay,
      );

      yield PlayGraphsLoaded(
        playsByDate: playsByDateData,
        playsByDayOfWeek: playsByDayOfWeekData,
        playsByHourOfDay: playsByHourOfDayData,
      );

      await getPlaysByDate(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      ).then(
        (failureOrPlayByDate) => add(
          PlayGraphsLoadPlaysByDate(
            tautulliId: event.tautulliId,
            failureOrPlayByDate: failureOrPlayByDate,
            yAxis: event.yAxis,
          ),
        ),
      );

      await getPlaysByDayOfWeek(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      ).then(
        (failureOrPlayByDayOfWeek) => add(
          PlayGraphsLoadPlaysByDayOfWeek(
            tautulliId: event.tautulliId,
            failureOrPlayByDayOfWeek: failureOrPlayByDayOfWeek,
            yAxis: event.yAxis,
          ),
        ),
      );

      await getPlaysByHourOfDay(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      ).then(
        (failureOrPlayByHourOfDay) => add(
          PlayGraphsLoadPlaysByHourOfDay(
            tautulliId: event.tautulliId,
            failureOrPlayByHourOfDay: failureOrPlayByHourOfDay,
            yAxis: event.yAxis,
          ),
        ),
      );
    }
    if (event is PlayGraphsLoadPlaysByDate) {
      if (currentState is PlayGraphsLoaded) {
        yield* event.failureOrPlayByDate.fold(
          (failure) async* {
            logging.error(
              'Graphs: Failed to load plays by date graph data',
            );

            _playsByDateCache = null;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByDate: GraphState(
                graphData: _playsByDateCache,
                graphCurrentState: GraphCurrentState.failure,
                graphType: GraphType.playsByDate,
                yAxis: event.yAxis,
                failureMessage:
                    FailureMapperHelper.mapFailureToMessage(failure),
                failureSuggestion:
                    FailureMapperHelper.mapFailureToSuggestion(failure),
                failure: failure,
              ),
            );
          },
          (graphData) async* {
            _playsByDateCache = graphData;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByDate: GraphState(
                graphData: graphData,
                graphCurrentState: GraphCurrentState.success,
                graphType: GraphType.playsByDate,
                yAxis: event.yAxis,
              ),
            );
          },
        );
      }
    }
    if (event is PlayGraphsLoadPlaysByDayOfWeek) {
      if (currentState is PlayGraphsLoaded) {
        yield* event.failureOrPlayByDayOfWeek.fold(
          (failure) async* {
            logging.error(
              'Graphs: Failed to load plays by day of the week graph data',
            );

            _playsByDayOfWeekCache = null;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByDayOfWeek: GraphState(
                graphData: _playsByDayOfWeekCache,
                graphCurrentState: GraphCurrentState.failure,
                graphType: GraphType.playsByDayOfWeek,
                yAxis: event.yAxis,
                failureMessage:
                    FailureMapperHelper.mapFailureToMessage(failure),
                failureSuggestion:
                    FailureMapperHelper.mapFailureToSuggestion(failure),
                failure: failure,
              ),
            );
          },
          (graphData) async* {
            _playsByDayOfWeekCache = graphData;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByDayOfWeek: GraphState(
                graphData: graphData,
                graphCurrentState: GraphCurrentState.success,
                graphType: GraphType.playsByDayOfWeek,
                yAxis: event.yAxis,
              ),
            );
          },
        );
      }
    }
    if (event is PlayGraphsLoadPlaysByHourOfDay) {
      if (currentState is PlayGraphsLoaded) {
        yield* event.failureOrPlayByHourOfDay.fold(
          (failure) async* {
            logging.error(
              'Graphs: Failed to load plays by day of the week graph data',
            );

            _playsByHourOfDayCache = null;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByHourOfDay: GraphState(
                graphData: _playsByHourOfDayCache,
                graphCurrentState: GraphCurrentState.failure,
                graphType: GraphType.playsByHourOfDay,
                yAxis: event.yAxis,
                failureMessage:
                    FailureMapperHelper.mapFailureToMessage(failure),
                failureSuggestion:
                    FailureMapperHelper.mapFailureToSuggestion(failure),
                failure: failure,
              ),
            );
          },
          (graphData) async* {
            _playsByHourOfDayCache = graphData;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByHourOfDay: GraphState(
                graphData: graphData,
                graphCurrentState: GraphCurrentState.success,
                graphType: GraphType.playsByHourOfDay,
                yAxis: event.yAxis,
              ),
            );
          },
        );
      }
    }
  }
}
