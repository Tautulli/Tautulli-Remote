import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../features/graphs/data/models/chart_data_model.dart';
import '../../features/graphs/data/models/graph_data_model.dart';
import '../../features/graphs/data/models/graph_series_data_model.dart';
import '../types/tautulli_types.dart';
import 'color_palette_helper.dart';

class GraphHelper {
  static ChartDataModel buildChartDataModel({
    required GraphYAxis yAxis,
    required GraphDataModel graphData,
  }) {
    // Calculate Max Y Value
    List<int> allYValues = [];
    for (var i = 0; i < graphData.seriesDataList.length; i++) {
      allYValues.addAll(List.from(graphData.seriesDataList[i].seriesData));
    }
    double maxYValue = allYValues.reduce(max).toDouble();

    // Calculate Horizontal Line Step
    late double horizontalLineStep;
    if (yAxis == GraphYAxis.time) {
      List<double> bins = [1800, 3600, 10800, 21600];

      late double durationBin;

      // If max y is more than 21600s (6h) then calculate a new bin in
      // increments of 21600s
      if (maxYValue > bins[bins.length - 1]) {
        durationBin = (maxYValue / 21600).ceilToDouble() * 21600;
      } else {
        for (double b in bins) {
          if (maxYValue <= b) {
            durationBin = b;
            break;
          }
        }
      }

      horizontalLineStep = durationBin / 6;
    }

    horizontalLineStep = (maxYValue / 5).ceilToDouble();

    // Calculate Vertical Line Step
    double verticalLineStep = (graphData.categories.length / 7).ceilToDouble();

    // Calculate Max Y Lines
    double maxYLines =
        (maxYValue / horizontalLineStep).ceilToDouble() * horizontalLineStep;

    return ChartDataModel(
      horizontalLineStep: horizontalLineStep,
      verticalLineStep: verticalLineStep,
      maxYLines: maxYLines,
    );
  }

  static List<LineChartBarData>? buildLineBarsData(GraphDataModel graphData) {
    List<LineChartBarData> lineBarsData = [];
    Map<GraphSeriesType, List<FlSpot>> spotListMap = {};

    graphData.seriesDataList;

    for (GraphSeriesDataModel seriesData in graphData.seriesDataList) {
      spotListMap[seriesData.seriesType] = [];
    }

    for (var i = 0; i < graphData.categories.length; i++) {
      for (var j = 0; j < spotListMap.keys.length; j++) {
        spotListMap[spotListMap.keys.toList()[j]]!.add(
          FlSpot(
            i.toDouble(),
            graphData.seriesDataList[j].seriesData[i].toDouble(),
          ),
        );
      }
    }

    for (GraphSeriesType seriesType in spotListMap.keys) {
      lineBarsData.add(
        LineChartBarData(
          isCurved: true,
          preventCurveOverShooting: true,
          spots: spotListMap[seriesType],
          color: [GraphSeriesType.tv, GraphSeriesType.directPlay]
                  .contains(seriesType)
              ? PlexColorPalette.gamboge
              : [GraphSeriesType.music, GraphSeriesType.transcode]
                      .contains(seriesType)
                  ? PlexColorPalette.cinnabar
                  : [GraphSeriesType.live].contains(seriesType)
                      ? PlexColorPalette.curiousBlue
                      : TautulliColorPalette.notWhite,
          dotData: FlDotData(
            show: false,
          ),
        ),
      );
    }

    return lineBarsData;
  }

  static String graphDate(
    String dateString, {
    bool includeWeekDay = false,
  }) {
    final dateFormat = includeWeekDay ? 'E MMM d' : 'MMM d';
    final parsedDateTime = DateTime.parse(dateString);
    final formatedDateString = DateFormat(dateFormat).format(parsedDateTime);
    return formatedDateString;
  }

  static String graphDuration(int durationInSeconds, {bool useDays = true}) {
    Duration time = Duration(seconds: durationInSeconds);

    if (useDays && time.inDays > 0) {
      return '${time.inDays}d ${time.inHours.remainder(24)}h ${time.inMinutes.remainder(60)}m';
    }

    if (time.inHours > 0) {
      return '${time.inHours}h ${time.inMinutes.remainder(60)}m';
    }

    return '${time.inMinutes.remainder(60)}m';
  }
}
