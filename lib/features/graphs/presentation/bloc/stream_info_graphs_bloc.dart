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
import '../../domain/usecases/get_plays_by_stream_type.dart';

part 'stream_info_graphs_event.dart';
part 'stream_info_graphs_state.dart';

GraphData _playsByStreamTypeCache;
String _yAxisCache;
int _timeRangeCache;

class StreamInfoGraphsBloc
    extends Bloc<StreamInfoGraphsEvent, StreamInfoGraphsState> {
  final GetPlaysByStreamType getPlaysByStreamType;
  final Logging logging;

  StreamInfoGraphsBloc({
    @required this.getPlaysByStreamType,
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

      yield StreamInfoGraphsLoaded(
        playsByStreamType: playsByStreamTypeData,
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
  }
}
