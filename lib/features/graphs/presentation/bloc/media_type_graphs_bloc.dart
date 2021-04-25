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
import '../../domain/usecases/get_plays_by_top_10_platforms.dart';
import '../../domain/usecases/get_plays_by_top_10_users.dart';

part 'media_type_graphs_event.dart';
part 'media_type_graphs_state.dart';

GraphData _playsByDateCache;
GraphData _playsByDayOfWeekCache;
GraphData _playsByHourOfDayCache;
GraphData _playsByTop10PlatformsCache;
GraphData _playsByTop10UsersCache;
String _yAxisCache;
int _timeRangeCache;

class MediaTypeGraphsBloc
    extends Bloc<MediaTypeGraphsEvent, MediaTypeGraphsState> {
  final GetPlaysByDate getPlaysByDate;
  final GetPlaysByDayOfWeek getPlaysByDayOfWeek;
  final GetPlaysByHourOfDay getPlaysByHourOfDay;
  final GetPlaysByTop10Platforms getPlaysByTop10Platforms;
  final GetPlaysByTop10Users getPlaysByTop10Users;
  final Logging logging;

  MediaTypeGraphsBloc({
    @required this.getPlaysByDate,
    @required this.getPlaysByDayOfWeek,
    @required this.getPlaysByHourOfDay,
    @required this.getPlaysByTop10Platforms,
    @required this.getPlaysByTop10Users,
    @required this.logging,
  }) : super(MediaTypeGraphsInitial(
          timeRange: _timeRangeCache,
        ));
  @override
  Stream<MediaTypeGraphsState> mapEventToState(
    MediaTypeGraphsEvent event,
  ) async* {
    final currentState = state;

    if (event is MediaTypeGraphsFetch) {
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

      GraphState playsByTop10PlatformsData = GraphState(
        graphData: _playsByTop10PlatformsCache,
        yAxis: _yAxisCache,
        graphCurrentState: GraphCurrentState.inProgress,
        graphType: GraphType.playsByTop10Platforms,
      );

      GraphState playsByTop10UsersData = GraphState(
        graphData: _playsByTop10UsersCache,
        yAxis: _yAxisCache,
        graphCurrentState: GraphCurrentState.inProgress,
        graphType: GraphType.playsByTop10Users,
      );

      yield MediaTypeGraphsLoaded(
        playsByDate: playsByDateData,
        playsByDayOfWeek: playsByDayOfWeekData,
        playsByHourOfDay: playsByHourOfDayData,
        playsByTop10Platforms: playsByTop10PlatformsData,
        playsByTop10Users: playsByTop10UsersData,
      );

      await getPlaysByDate(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      ).then(
        (failureOrPlaysByDate) => add(
          MediaTypeGraphsLoadPlaysByDate(
            tautulliId: event.tautulliId,
            failureOrPlaysByDate: failureOrPlaysByDate,
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
        (failureOrPlaysByDayOfWeek) => add(
          MediaTypeGraphsLoadPlaysByDayOfWeek(
            tautulliId: event.tautulliId,
            failureOrPlaysByDayOfWeek: failureOrPlaysByDayOfWeek,
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
        (failureOrPlaysByHourOfDay) => add(
          MediaTypeGraphsLoadPlaysByHourOfDay(
            tautulliId: event.tautulliId,
            failureOrPlaysByHourOfDay: failureOrPlaysByHourOfDay,
            yAxis: event.yAxis,
          ),
        ),
      );

      await getPlaysByTop10Platforms(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      ).then(
        (failureOrPlaysByTop10Platforms) => add(
          MediaTypeGraphsLoadPlaysByTop10Platforms(
            tautulliId: event.tautulliId,
            failureOrPlaysByTop10Platforms: failureOrPlaysByTop10Platforms,
            yAxis: event.yAxis,
          ),
        ),
      );

      await getPlaysByTop10Users(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      ).then(
        (failureOrPlaysByTop10Users) => add(
          MediaTypeGraphsLoadPlaysByTop10Users(
            tautulliId: event.tautulliId,
            failureOrPlaysByTop10Users: failureOrPlaysByTop10Users,
            yAxis: event.yAxis,
          ),
        ),
      );
    }
    if (event is MediaTypeGraphsLoadPlaysByDate) {
      if (currentState is MediaTypeGraphsLoaded) {
        yield* event.failureOrPlaysByDate.fold(
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
    if (event is MediaTypeGraphsLoadPlaysByDayOfWeek) {
      if (currentState is MediaTypeGraphsLoaded) {
        yield* event.failureOrPlaysByDayOfWeek.fold(
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
    if (event is MediaTypeGraphsLoadPlaysByHourOfDay) {
      if (currentState is MediaTypeGraphsLoaded) {
        yield* event.failureOrPlaysByHourOfDay.fold(
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
    if (event is MediaTypeGraphsLoadPlaysByTop10Platforms) {
      if (currentState is MediaTypeGraphsLoaded) {
        yield* event.failureOrPlaysByTop10Platforms.fold(
          (failure) async* {
            logging.error(
              'Graphs: Failed to load plays by day of the week graph data',
            );

            _playsByTop10PlatformsCache = null;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByTop10Platforms: GraphState(
                graphData: _playsByTop10PlatformsCache,
                graphCurrentState: GraphCurrentState.failure,
                graphType: GraphType.playsByTop10Platforms,
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
            _playsByTop10PlatformsCache = graphData;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByTop10Platforms: GraphState(
                graphData: graphData,
                graphCurrentState: GraphCurrentState.success,
                graphType: GraphType.playsByTop10Platforms,
                yAxis: event.yAxis,
              ),
            );
          },
        );
      }
    }
    if (event is MediaTypeGraphsLoadPlaysByTop10Users) {
      if (currentState is MediaTypeGraphsLoaded) {
        yield* event.failureOrPlaysByTop10Users.fold(
          (failure) async* {
            logging.error(
              'Graphs: Failed to load plays by day of the week graph data',
            );

            _playsByTop10UsersCache = null;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByTop10Users: GraphState(
                graphData: _playsByTop10UsersCache,
                graphCurrentState: GraphCurrentState.failure,
                graphType: GraphType.playsByTop10Users,
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
            _playsByTop10UsersCache = graphData;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByTop10Users: GraphState(
                graphData: graphData,
                graphCurrentState: GraphCurrentState.success,
                graphType: GraphType.playsByTop10Users,
                yAxis: event.yAxis,
              ),
            );
          },
        );
      }
    }
  }
}
