// @dart=2.9

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
import '../../domain/usecases/get_plays_per_month.dart';

part 'play_totals_graphs_event.dart';
part 'play_totals_graphs_state.dart';

GraphData _playsPerMonthCache;
String _yAxisCache;
int _timeRangeCache;

class PlayTotalsGraphsBloc
    extends Bloc<PlayTotalsGraphsEvent, PlayTotalsGraphsState> {
  final GetPlaysPerMonth getPlaysPerMonth;
  final Logging logging;

  PlayTotalsGraphsBloc({
    @required this.getPlaysPerMonth,
    @required this.logging,
  }) : super(PlayTotalsGraphsInitial(
          timeRange: _timeRangeCache,
        ));

  @override
  Stream<PlayTotalsGraphsState> mapEventToState(
    PlayTotalsGraphsEvent event,
  ) async* {
    final currentState = state;

    if (event is PlayTotalsGraphsFetch) {
      _timeRangeCache = event.timeRange;

      GraphState playsPerMonthData = GraphState(
        graphData: _playsPerMonthCache,
        yAxis: _yAxisCache,
        graphCurrentState: GraphCurrentState.inProgress,
        graphType: GraphType.playsPerMonth,
      );

      yield PlayTotalsGraphsLoaded(
        playsPerMonth: playsPerMonthData,
      );

      await getPlaysPerMonth(
        tautulliId: event.tautulliId,
        // timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      ).then(
        (failureOrPlaysPerMonth) => add(
          PlayTotalsGraphsLoadPlaysPerMonth(
            tautulliId: event.tautulliId,
            failureOrPlaysPerMonth: failureOrPlaysPerMonth,
            yAxis: event.yAxis,
          ),
        ),
      );
    }
    if (event is PlayTotalsGraphsLoadPlaysPerMonth) {
      if (currentState is PlayTotalsGraphsLoaded) {
        yield* event.failureOrPlaysPerMonth.fold(
          (failure) async* {
            logging.error(
              'Graphs: Failed to load plays per month graph data',
            );

            _playsPerMonthCache = null;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsPerMonth: GraphState(
                graphData: _playsPerMonthCache,
                graphCurrentState: GraphCurrentState.failure,
                graphType: GraphType.playsPerMonth,
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
            // print(graphData);
            _playsPerMonthCache = graphData;
            _yAxisCache = event.yAxis;

            yield currentState.copyWith(
              playsPerMonth: GraphState(
                graphData: graphData,
                graphCurrentState: GraphCurrentState.success,
                graphType: GraphType.playsPerMonth,
                yAxis: event.yAxis,
              ),
            );
          },
        );
      }
    }
  }
}
