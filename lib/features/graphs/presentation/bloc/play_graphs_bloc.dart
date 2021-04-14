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

part 'play_graphs_event.dart';
part 'play_graphs_state.dart';

GraphData _playsByDateCache;

class PlayGraphsBloc extends Bloc<PlayGraphsEvent, PlayGraphsState> {
  final GetPlaysByDate getPlaysByDate;
  final Logging logging;

  PlayGraphsBloc({
    @required this.getPlaysByDate,
    @required this.logging,
  }) : super(PlayGraphsInitial());
  @override
  Stream<PlayGraphsState> mapEventToState(
    PlayGraphsEvent event,
  ) async* {
    if (event is PlayGraphsFetch) {
      GraphState playsByDateData = GraphState(
        graphData: _playsByDateCache,
        graphCurrentState: GraphCurrentState.inProgress,
      );

      yield PlayGraphsLoaded(playsByDate: playsByDateData);

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
          ),
        ),
      );
    }
    if (event is PlayGraphsLoadPlaysByDate) {
      yield* event.failureOrPlayByDate.fold(
        (failure) async* {
          logging.error(
            'Graphs: Failed to load plays by date graph data',
          );

          _playsByDateCache = null;

          yield PlayGraphsLoaded(
            playsByDate: GraphState(
              graphData: _playsByDateCache,
              graphCurrentState: GraphCurrentState.failure,
              failureMessage: FailureMapperHelper.mapFailureToMessage(failure),
              failureSuggestion:
                  FailureMapperHelper.mapFailureToSuggestion(failure),
              failure: failure,
            ),
          );
        },
        (graphData) async* {
          _playsByDateCache = graphData;

          yield PlayGraphsLoaded(
            playsByDate: GraphState(
              graphData: graphData,
              graphCurrentState: GraphCurrentState.success,
            ),
          );
        },
      );
    }
  }
}
