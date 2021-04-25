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
import '../../domain/usecases/get_plays_by_source_resolution.dart';
import '../../domain/usecases/get_plays_by_stream_resolution.dart';
import '../../domain/usecases/get_plays_by_stream_type.dart';

part 'stream_info_graphs_event.dart';
part 'stream_info_graphs_state.dart';

GraphData _playsByStreamTypeCache;
GraphData _playsBySourceResolutionCache;
GraphData _playsByStreamResolutionCache;
String _yAxisCache;
int _timeRangeCache;

class StreamInfoGraphsBloc
    extends Bloc<StreamInfoGraphsEvent, StreamInfoGraphsState> {
  final GetPlaysByStreamType getPlaysByStreamType;
  final GetPlaysBySourceResolution getPlaysBySourceResolution;
  final GetPlaysByStreamResolution getPlaysByStreamResolution;
  final Logging logging;

  StreamInfoGraphsBloc({
    @required this.getPlaysByStreamType,
    @required this.getPlaysBySourceResolution,
    @required this.getPlaysByStreamResolution,
    @required this.logging,
  }) : super(StreamInfoGraphsInitial(
          timeRange: _timeRangeCache,
        ));

  @override
  Stream<StreamInfoGraphsState> mapEventToState(
    StreamInfoGraphsEvent event,
  ) async* {
    final currentState = state;

    if (event is StreamInfoGraphsFetch) {
      _timeRangeCache = event.timeRange;

      GraphState playsByStreamTypeData = GraphState(
        graphData: _playsByStreamTypeCache,
        yAxis: _yAxisCache,
        graphCurrentState: GraphCurrentState.inProgress,
        graphType: GraphType.playsByStreamType,
      );

      GraphState playsBySourceResolutionData = GraphState(
        graphData: _playsBySourceResolutionCache,
        yAxis: _yAxisCache,
        graphCurrentState: GraphCurrentState.inProgress,
        graphType: GraphType.playsBySourceResolution,
      );

      GraphState playsByStreamResolutionData = GraphState(
        graphData: _playsByStreamResolutionCache,
        yAxis: _yAxisCache,
        graphCurrentState: GraphCurrentState.inProgress,
        graphType: GraphType.playsByStreamResolution,
      );

      yield StreamInfoGraphsLoaded(
        playsByStreamType: playsByStreamTypeData,
        playsBySourceResolution: playsBySourceResolutionData,
        playsByStreamResolution: playsByStreamResolutionData,
      );

      await getPlaysByStreamType(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      ).then(
        (failureOrPlaysByStreamType) => add(
          StreamInfoGraphsLoadPlaysByStreamType(
            tautulliId: event.tautulliId,
            failureOrPlaysByStreamType: failureOrPlaysByStreamType,
            yAxis: event.yAxis,
          ),
        ),
      );

      await getPlaysBySourceResolution(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      ).then(
        (failureOrPlaysBySourceResolution) => add(
          StreamInfoGraphsLoadPlaysBySourceResolution(
            tautulliId: event.tautulliId,
            failureOrPlaysBySourceResolution: failureOrPlaysBySourceResolution,
            yAxis: event.yAxis,
          ),
        ),
      );

      await getPlaysByStreamResolution(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      ).then(
        (failureOrPlaysByStreamResolution) => add(
          StreamInfoGraphsLoadPlaysByStreamResolution(
            tautulliId: event.tautulliId,
            failureOrPlaysByStreamResolution: failureOrPlaysByStreamResolution,
            yAxis: event.yAxis,
          ),
        ),
      );
    }
    if (event is StreamInfoGraphsLoadPlaysByStreamType) {
      if (currentState is StreamInfoGraphsLoaded) {
        yield* event.failureOrPlaysByStreamType.fold(
          (failure) async* {
            logging.error(
              'Graphs: Failed to load plays by stream type graph data',
            );

            _playsByStreamTypeCache = null;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByStreamType: GraphState(
                graphData: _playsByStreamTypeCache,
                graphCurrentState: GraphCurrentState.failure,
                graphType: GraphType.playsByStreamType,
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
            _playsByStreamTypeCache = graphData;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByStreamType: GraphState(
                graphData: graphData,
                graphCurrentState: GraphCurrentState.success,
                graphType: GraphType.playsByStreamType,
                yAxis: event.yAxis,
              ),
            );
          },
        );
      }
    }
    if (event is StreamInfoGraphsLoadPlaysBySourceResolution) {
      if (currentState is StreamInfoGraphsLoaded) {
        yield* event.failureOrPlaysBySourceResolution.fold(
          (failure) async* {
            logging.error(
              'Graphs: Failed to load plays by stream type graph data',
            );

            _playsBySourceResolutionCache = null;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsBySourceResolution: GraphState(
                graphData: _playsBySourceResolutionCache,
                graphCurrentState: GraphCurrentState.failure,
                graphType: GraphType.playsBySourceResolution,
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
            _playsBySourceResolutionCache = graphData;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsBySourceResolution: GraphState(
                graphData: graphData,
                graphCurrentState: GraphCurrentState.success,
                graphType: GraphType.playsBySourceResolution,
                yAxis: event.yAxis,
              ),
            );
          },
        );
      }
    }
    if (event is StreamInfoGraphsLoadPlaysByStreamResolution) {
      if (currentState is StreamInfoGraphsLoaded) {
        yield* event.failureOrPlaysByStreamResolution.fold(
          (failure) async* {
            logging.error(
              'Graphs: Failed to load plays by stream type graph data',
            );

            _playsByStreamResolutionCache = null;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByStreamResolution: GraphState(
                graphData: _playsByStreamResolutionCache,
                graphCurrentState: GraphCurrentState.failure,
                graphType: GraphType.playsByStreamResolution,
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
            _playsByStreamResolutionCache = graphData;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsByStreamResolution: GraphState(
                graphData: graphData,
                graphCurrentState: GraphCurrentState.success,
                graphType: GraphType.playsByStreamResolution,
                yAxis: event.yAxis,
              ),
            );
          },
        );
      }
    }
  }
}
