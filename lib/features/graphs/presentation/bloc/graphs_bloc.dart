// ignore_for_file: prefer_const_constructors

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
int? timeRangeCache;
Map<GraphType, GraphModel> graphsCache = Map.of(defaultGraphs);

Map<GraphType, GraphModel> defaultGraphs = {
  GraphType.playsByDate: GraphModel(
    graphType: GraphType.playsByDate,
    status: BlocStatus.initial,
  ),
  GraphType.playsByDayOfWeek: GraphModel(
    graphType: GraphType.playsByDayOfWeek,
    status: BlocStatus.initial,
  ),
  GraphType.playsByHourOfDay: GraphModel(
    graphType: GraphType.playsByHourOfDay,
    status: BlocStatus.initial,
  ),
  GraphType.playsBySourceResolution: GraphModel(
    graphType: GraphType.playsBySourceResolution,
    status: BlocStatus.initial,
  ),
  GraphType.playsByStreamResolution: GraphModel(
    graphType: GraphType.playsByStreamResolution,
    status: BlocStatus.initial,
  ),
  GraphType.playsByStreamType: GraphModel(
    graphType: GraphType.playsByStreamType,
    status: BlocStatus.initial,
  ),
  GraphType.playsByTop10Platforms: GraphModel(
    graphType: GraphType.playsByTop10Platforms,
    status: BlocStatus.initial,
  ),
  GraphType.playsByTop10Users: GraphModel(
    graphType: GraphType.playsByTop10Users,
    status: BlocStatus.initial,
  ),
  GraphType.playsPerMonth: GraphModel(
    graphType: GraphType.playsPerMonth,
    status: BlocStatus.initial,
  ),
  GraphType.streamTypeByTop10Platforms: GraphModel(
    graphType: GraphType.streamTypeByTop10Platforms,
    status: BlocStatus.initial,
  ),
  GraphType.streamTypeByTop10Users: GraphModel(
    graphType: GraphType.streamTypeByTop10Users,
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
            timeRange: timeRangeCache ?? 30,
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

    if (event.freshFetch || (tautulliIdCache != null && serverChange)) {
      for (GraphType graphType in graphsCache.keys) {
        graphsCache[graphType] = graphsCache[graphType]!.copyWith(
          status: BlocStatus.initial,
        );
      }

      emit(
        state.copyWith(
          yAxis: yAxisCache,
          timeRange: timeRangeCache,
          graphs: Map.of(graphsCache),
        ),
      );
    }

    graphsCache = defaultGraphs;
    tautulliIdCache = event.tautulliId;
    yAxisCache = event.yAxis;
    timeRangeCache = event.timeRange;

    graphs
        .getPlaysByDate(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          timeRange: event.timeRange,
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
        .getPlaysByDayOfWeek(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          timeRange: event.timeRange,
          userId: event.userId,
          grouping: event.grouping,
        )
        .then(
          (failureOrGetPlaysByDayOfWeek) => add(
            GraphsEmit(
              graphType: GraphType.playsByDayOfWeek,
              failureOrGraph: failureOrGetPlaysByDayOfWeek,
              tautulliId: event.tautulliId,
              settingsBloc: event.settingsBloc,
            ),
          ),
        );

    graphs
        .getPlaysByHourOfDay(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          timeRange: event.timeRange,
          userId: event.userId,
          grouping: event.grouping,
        )
        .then(
          (failureOrGetPlaysByHourOfDay) => add(
            GraphsEmit(
              graphType: GraphType.playsByHourOfDay,
              failureOrGraph: failureOrGetPlaysByHourOfDay,
              tautulliId: event.tautulliId,
              settingsBloc: event.settingsBloc,
            ),
          ),
        );

    graphs
        .getPlaysBySourceResolution(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          timeRange: event.timeRange,
          userId: event.userId,
          grouping: event.grouping,
        )
        .then(
          (failureOrGetPlaysBySourceResolution) => add(
            GraphsEmit(
              graphType: GraphType.playsBySourceResolution,
              failureOrGraph: failureOrGetPlaysBySourceResolution,
              tautulliId: event.tautulliId,
              settingsBloc: event.settingsBloc,
            ),
          ),
        );

    graphs
        .getPlaysByStreamResolution(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          timeRange: event.timeRange,
          userId: event.userId,
          grouping: event.grouping,
        )
        .then(
          (failureOrGetPlaysByStreamResolution) => add(
            GraphsEmit(
              graphType: GraphType.playsByStreamResolution,
              failureOrGraph: failureOrGetPlaysByStreamResolution,
              tautulliId: event.tautulliId,
              settingsBloc: event.settingsBloc,
            ),
          ),
        );

    graphs
        .getPlaysByStreamType(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          timeRange: event.timeRange,
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

    graphs
        .getPlaysPerMonth(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          timeRange: 12,
          userId: event.userId,
          grouping: event.grouping,
        )
        .then(
          (failureOrGetPlaysPerMonth) => add(
            GraphsEmit(
              graphType: GraphType.playsPerMonth,
              failureOrGraph: failureOrGetPlaysPerMonth,
              tautulliId: event.tautulliId,
              settingsBloc: event.settingsBloc,
            ),
          ),
        );

    graphs
        .getPlaysByTop10Platforms(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          timeRange: event.timeRange,
          userId: event.userId,
          grouping: event.grouping,
        )
        .then(
          (failureOrGetPlaysByTop10Platforms) => add(
            GraphsEmit(
              graphType: GraphType.playsByTop10Platforms,
              failureOrGraph: failureOrGetPlaysByTop10Platforms,
              tautulliId: event.tautulliId,
              settingsBloc: event.settingsBloc,
            ),
          ),
        );

    graphs
        .getPlaysByTop10Users(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          timeRange: event.timeRange,
          userId: event.userId,
          grouping: event.grouping,
        )
        .then(
          (failureOrGetPlaysByTop10Users) => add(
            GraphsEmit(
              graphType: GraphType.playsByTop10Users,
              failureOrGraph: failureOrGetPlaysByTop10Users,
              tautulliId: event.tautulliId,
              settingsBloc: event.settingsBloc,
            ),
          ),
        );

    graphs
        .getStreamTypeByTop10Platforms(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          timeRange: event.timeRange,
          userId: event.userId,
          grouping: event.grouping,
        )
        .then(
          (failureOrGetStreamTypeByTop10Platforms) => add(
            GraphsEmit(
              graphType: GraphType.streamTypeByTop10Platforms,
              failureOrGraph: failureOrGetStreamTypeByTop10Platforms,
              tautulliId: event.tautulliId,
              settingsBloc: event.settingsBloc,
            ),
          ),
        );

    graphs
        .getStreamTypeByTop10Users(
          tautulliId: event.tautulliId,
          yAxis: event.yAxis,
          timeRange: event.timeRange,
          userId: event.userId,
          grouping: event.grouping,
        )
        .then(
          (failureOrGetStreamTypeByTop10Users) => add(
            GraphsEmit(
              graphType: GraphType.streamTypeByTop10Users,
              failureOrGraph: failureOrGetStreamTypeByTop10Users,
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
          'Graphs :: Failed to fetch ${event.graphType.graphEndpoint()} data [$failure]',
        );

        graphsCache[event.graphType] = graphsCache[event.graphType]!.copyWith(
          status: BlocStatus.failure,
          failure: failure,
          failureMessage: FailureHelper.mapFailureToMessage(failure),
          failureSuggestion: FailureHelper.mapFailureToSuggestion(failure),
        );

        emit(
          state.copyWith(
            yAxis: yAxisCache,
            timeRange: timeRangeCache,
            graphs: Map.of(graphsCache),
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
            yAxis: yAxisCache,
            timeRange: timeRangeCache,
            graphs: Map.of(graphsCache),
          ),
        );
      },
    );
  }
}
