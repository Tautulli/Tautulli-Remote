import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/graph_type.dart';
import '../../../../core/types/graph_y_axis.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/graph_data_model.dart';
import '../../data/models/graph_model.dart';
import '../../domain/usecases/graphs.dart';

part 'graphs_event.dart';
part 'graphs_state.dart';

String? tautulliIdCache;
GraphYAxis? yAxisCache;
Map<GraphType, GraphModel> graphsCache = Map.of(defaultGraphs);
GraphDataModel? playsByDateCache;
GraphDataModel? playsByStreamTypeCache;

const Map<GraphType, GraphModel> defaultGraphs = {
  GraphType.playsByDate: GraphModel(
    graphType: GraphType.playsByDate,
    status: BlocStatus.initial,
  ),
  GraphType.playsByStreamType: GraphModel(
    graphType: GraphType.playsByStreamType,
    status: BlocStatus.initial,
  ),
};

class GraphsBloc extends Bloc<GraphsEvent, GraphsState> {
  final Graphs graphs;
  final Logging logging;

  GraphsBloc({
    required this.graphs,
    required this.logging,
  }) : super(
          GraphsState(
            yAxis: yAxisCache ?? GraphYAxis.plays,
            graphs: graphsCache,
          ),
        ) {
    on<GraphsFetched>(_onGraphsFetched);
    on<GraphsEmit>(_onGraphsEmit);
  }

  void _onGraphsFetched(
    GraphsFetched event,
    Emitter<GraphsState> emit,
  ) async {
    final bool serverChange = tautulliIdCache != event.tautulliId;

    if (event.freshFetch) {
      for (GraphType graphType in graphsCache.keys) {
        graphsCache[graphType] = graphsCache[graphType]!.copyWith(
          status: BlocStatus.initial,
        );
      }

      emit(
        state.copyWith(
          graphs: graphsCache,
        ),
      );
    } else if (tautulliIdCache != null && serverChange) {
      emit(
        state.copyWith(
          graphs: defaultGraphs,
        ),
      );
      graphsCache = defaultGraphs;
    }

    tautulliIdCache = event.tautulliId;
    yAxisCache = event.yAxis;

    graphs
        .getPlaysByDate(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          userId: event.userId,
          grouping: event.grouping,
        )
        .then(
          (failureOrGetPlaysByDate) => add(
            GraphsEmit(
              graphType: GraphType.playsByDate,
              failureOrGraph: failureOrGetPlaysByDate,
              tautulliId: event.tautulliId,
              settingsBloc: event.settingsBloc,
            ),
          ),
        );

    graphs
        .getPlaysByStreamType(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          userId: event.userId,
          grouping: event.grouping,
        )
        .then(
          (failureOrGetPlaysByStreamType) => add(
            GraphsEmit(
              graphType: GraphType.playsByStreamType,
              failureOrGraph: failureOrGetPlaysByStreamType,
              tautulliId: event.tautulliId,
              settingsBloc: event.settingsBloc,
            ),
          ),
        );
  }

  void _onGraphsEmit(
    GraphsEmit event,
    Emitter<GraphsState> emit,
  ) {
    event.failureOrGraph.fold(
      (failure) {
        logging.error(
          'Graphs :: Failed to fetch Plays By Stream Type data [$failure]',
        );

        graphsCache[event.graphType] = graphsCache[event.graphType]!.copyWith(
          status: BlocStatus.failure,
          failure: failure,
          failureMessage: FailureHelper.mapFailureToMessage(failure),
          failureSuggestion: FailureHelper.mapFailureToSuggestion(failure),
        );

        emit(
          state.copyWith(
            graphs: graphsCache,
          ),
        );
      },
      (playsByStreamType) {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.tautulliId,
            primaryActive: playsByStreamType.value2,
          ),
        );

        graphsCache[event.graphType] = graphsCache[event.graphType]!.copyWith(
          status: BlocStatus.success,
          graphDataModel: playsByStreamType.value1,
        );

        emit(
          state.copyWith(
            graphs: graphsCache,
          ),
        );
      },
    );
  }
}
