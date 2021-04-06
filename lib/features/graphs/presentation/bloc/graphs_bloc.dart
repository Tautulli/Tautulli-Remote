import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tautulli_remote/core/helpers/color_palette_helper.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
          // Create lists of data pairs
          List<DataTest> tvData = [];
          List<DataTest> moviesData = [];
          List<DataTest> musicData = [];
          List<String> categories = graphData.categories;
          List<SeriesData> seriesDataList = graphData.seriesDataList;
          for (var i = 0; i < seriesDataList.length; i++) {
            SeriesType seriesType = seriesDataList[i].seriesType;
            List seriesData = seriesDataList[i].seriesData;
            for (var j = 0; j < seriesData.length; j++) {
              if (seriesType == SeriesType.tv) {
                tvData.add(
                  DataTest(j, seriesData[j], TautulliColorPalette.amber),
                );
              } else if (seriesType == SeriesType.movies) {
                moviesData.add(
                  DataTest(j, seriesData[j], TautulliColorPalette.not_white),
                );
              } else if (seriesType == SeriesType.music) {
                musicData.add(
                  DataTest(j, seriesData[j], PlexColorPalette.cinnabar),
                );
              }
            }
          }

          List<charts.Series<DataTest, int>> chartData = [
            charts.Series<DataTest, int>(
              id: 'TV',
              colorFn: (DataTest data, _) => data.color,
              domainFn: (DataTest data, _) => data.xAxis,
              measureFn: (DataTest data, _) => data.yAxis,
              data: tvData,
            ),
            charts.Series<DataTest, int>(
              id: 'Movies',
              colorFn: (DataTest data, _) => data.color,
              domainFn: (DataTest data, _) => data.xAxis,
              measureFn: (DataTest data, _) => data.yAxis,
              data: moviesData,
            ),
            charts.Series<DataTest, int>(
              id: 'Music',
              colorFn: (DataTest data, _) => data.color,
              domainFn: (DataTest data, _) => data.xAxis,
              measureFn: (DataTest data, _) => data.yAxis,
              data: musicData,
            ),
          ];

          print(chartData);
          yield GraphsSuccess(
            playsByDate: graphData,
            chartData: chartData,
          );
        },
      );
    }
  }
}

class DataTest {
  final int xAxis;
  final int yAxis;
  final charts.Color color;

  DataTest(this.xAxis, this.yAxis, Color color)
      : this.color = charts.Color(
          r: color.red,
          g: color.green,
          b: color.blue,
          a: color.alpha,
        );
}
