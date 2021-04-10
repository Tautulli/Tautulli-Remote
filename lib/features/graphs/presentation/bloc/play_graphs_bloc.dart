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
import '../../domain/usecases/get_plays_by_date.dart';

part 'play_graphs_event.dart';
part 'play_graphs_state.dart';

SettingsBloc _settingsBlocCache;

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
    final currentState = state;

    if (event is PlayGraphsFetch) {
      yield PlayGraphsInProgress();

      _settingsBlocCache = event.settingsBloc;

      await getPlaysByDate(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      ).then(
        (failureOrPlayByDate) => add(
          PlayGraphsLoadPlaysByDateGraph(
            tautulliId: event.tautulliId,
            failureOrPlayByDate: failureOrPlayByDate,
          ),
        ),
      );
    }
    if (event is PlayGraphsLoadPlaysByDateGraph) {
      yield* event.failureOrPlayByDate.fold(
        (failure) async* {
          logging.error(
            'Graphs: Failed to load plays by date graph data',
          );

          yield PlayGraphsFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (graphData) async* {
          if (currentState is PlayGraphsSuccess) {
            currentState.copyWith(playsByDate: graphData);
          } else {
            yield PlayGraphsSuccess(
              playsByDate: graphData,
            );
          }
        },
      );
    }
    if (event is PlayGraphsFilter) {
      yield PlayGraphsInProgress();

      final failureOrPlayByDate = await getPlaysByDate(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: _settingsBlocCache,
      );

      yield* failureOrPlayByDate.fold(
        (failure) async* {
          logging.error(
            'Graphs: Failed to load plays by date graph data',
          );

          yield PlayGraphsFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (graphData) async* {
          yield PlayGraphsSuccess(
            playsByDate: graphData,
          );
        },
      );
    }
  }
}
