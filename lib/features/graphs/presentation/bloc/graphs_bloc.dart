import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/graph_data.dart';
import '../../domain/usecases/get_plays_by_date.dart';

part 'graphs_event.dart';
part 'graphs_state.dart';

class GraphsBloc extends Bloc<GraphsEvent, GraphsState> {
  final GetPlaysByDate getPlaysByDate;
  final Logging logging;

  GraphsBloc({
    @required this.getPlaysByDate,
    @required this.logging,
  }) : super(GraphsInitial());
  @override
  Stream<GraphsState> mapEventToState(
    GraphsEvent event,
  ) async* {
    if (event is GraphsFetch) {
      final failureOrPlayByDate = await getPlaysByDate(
        tautulliId: event.tautulliId,
        timeRange: event.timeRange,
        yAxis: event.yAxis,
        userId: event.userId,
        grouping: event.grouping,
        settingsBloc: event.settingsBloc,
      );

      yield* failureOrPlayByDate.fold(
        (failure) async* {
          logging.error(
            'Graphs: Failed to load plays by date graph data',
          );

          yield GraphsFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (graphData) async* {
          yield GraphsSuccess(
            playsByDate: graphData,
          );
        },
      );
    }
  }
}
