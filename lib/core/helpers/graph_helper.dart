import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/graphs/data/models/chart_data_model.dart';
import '../../features/graphs/data/models/graph_data_model.dart';
import '../../features/graphs/data/models/graph_series_data_model.dart';
import '../types/tautulli_types.dart';
import 'color_palette_helper.dart';

class GraphHelper {
  static ChartDataModel buildBarChartDataModel({
    required GraphYAxis yAxis,
    required GraphDataModel graphData,
    required double textScaleFactor,
  }) {
    // Calculate Max Y Value
    double maxYValue = List<int>.generate(graphData.categories.length, (index) {
      num value = 0;
      for (GraphSeriesDataModel seriesDataModel in graphData.seriesDataList) {
        value = value + seriesDataModel.seriesData[index];
      }
      return value.toInt();
    }).reduce(max).toDouble();

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
    } else {
      horizontalLineStep = (maxYValue / 5).ceilToDouble();
    }

    // Left Reserved Size
    late int longestYValue;
    late double leftReservedSize;
    if (yAxis == GraphYAxis.plays) {
      longestYValue = (horizontalLineStep * 5).toInt().toString().length;
    } else {
      longestYValue = GraphHelper.graphDuration(
        (horizontalLineStep * 6).toInt(),
        useDays: false,
      ).length;
    }

    if (longestYValue < 3) {
      leftReservedSize = 19 * textScaleFactor;
    } else if (longestYValue == 3) {
      leftReservedSize = 26 * textScaleFactor;
    } else if (longestYValue == 4) {
      leftReservedSize = 33 * textScaleFactor;
    } else if (longestYValue == 5) {
      leftReservedSize = 41 * textScaleFactor;
    } else if (longestYValue == 6) {
      leftReservedSize = 48 * textScaleFactor;
    } else if (longestYValue == 7) {
      leftReservedSize = 55 * textScaleFactor;
    } else if (longestYValue == 8) {
      leftReservedSize = 62 * textScaleFactor;
    } else {
      leftReservedSize = 66 * textScaleFactor;
    }

    // Calculate Vertical Line Step
    double verticalLineStep = (graphData.categories.length / 7).ceilToDouble();

    // Calculate Max Y Lines
    double maxYLines =
        (maxYValue / horizontalLineStep).ceilToDouble() * horizontalLineStep;

    return ChartDataModel(
      horizontalLineStep: horizontalLineStep,
      verticalLineStep: verticalLineStep,
      leftReservedSize: leftReservedSize,
      maxYLines: maxYLines,
    );
  }

  static List<BarChartGroupData>? buildBarGroups({
    required GraphDataModel graphData,
    required double screenWidth,
  }) {
    List<BarChartGroupData> barGroups = [];
    for (var i = 0; i < graphData.categories.length; i++) {
      Map<GraphSeriesType, double?> barValues = {};

      for (GraphSeriesDataModel seriesData in graphData.seriesDataList) {
        barValues[seriesData.seriesType] = seriesData.seriesData[i].toDouble();
      }

      double maxBarY = 0;

      for (GraphSeriesType seriesType in barValues.keys) {
        maxBarY += barValues[seriesType]!;
      }

      double barStart = 0;
      List<BarChartRodStackItem> rodStackItems = [];

      if (barValues.containsKey(GraphSeriesType.live)) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            barValues[GraphSeriesType.live]! + barStart,
            PlexColorPalette.curiousBlue,
          ),
        );

        barStart = barStart + barValues[GraphSeriesType.live]!;
      }

      if (barValues.containsKey(GraphSeriesType.music)) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            barValues[GraphSeriesType.music]! + barStart,
            PlexColorPalette.cinnabar,
          ),
        );

        barStart = barStart + barValues[GraphSeriesType.music]!;
      }

      if (barValues.containsKey(GraphSeriesType.transcode)) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            barValues[GraphSeriesType.transcode]! + barStart,
            PlexColorPalette.cinnabar,
          ),
        );

        barStart = barStart + barValues[GraphSeriesType.transcode]!;
      }

      if (barValues.containsKey(GraphSeriesType.movies)) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            barValues[GraphSeriesType.movies]! + barStart,
            TautulliColorPalette.notWhite,
          ),
        );

        barStart = barStart + barValues[GraphSeriesType.movies]!;
      }

      if (barValues.containsKey(GraphSeriesType.directStream)) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            barValues[GraphSeriesType.directStream]! + barStart,
            TautulliColorPalette.notWhite,
          ),
        );

        barStart = barStart + barValues[GraphSeriesType.directStream]!;
      }

      if (barValues.containsKey(GraphSeriesType.tv)) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            barValues[GraphSeriesType.tv]! + barStart,
            PlexColorPalette.gamboge,
          ),
        );

        barStart = barStart + barValues[GraphSeriesType.tv]!;
      }

      if (barValues.containsKey(GraphSeriesType.directPlay)) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            barValues[GraphSeriesType.directPlay]! + barStart,
            PlexColorPalette.gamboge,
          ),
        );

        barStart = barStart + barValues[GraphSeriesType.directPlay]!;
      }

      final test = screenWidth / graphData.categories.length / 2.5;
      // print(test);

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: maxBarY,
              width: test, //TODO
              color: Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
              rodStackItems: rodStackItems,
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  static ChartDataModel buildLineChartDataModel({
    required GraphYAxis yAxis,
    required GraphDataModel graphData,
    required double textScaleFactor,
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
    } else {
      horizontalLineStep = (maxYValue / 5).ceilToDouble();
    }

    // Left Reserved Size
    late int longestYValue;
    late double leftReservedSize;
    if (yAxis == GraphYAxis.plays) {
      longestYValue = (horizontalLineStep * 5).toInt().toString().length;
    } else {
      longestYValue = GraphHelper.graphDuration(
        (horizontalLineStep * 6).toInt(),
        useDays: false,
      ).length;
    }

    if (longestYValue < 3) {
      leftReservedSize = 19 * textScaleFactor;
    } else if (longestYValue == 3) {
      leftReservedSize = 26 * textScaleFactor;
    } else if (longestYValue == 4) {
      leftReservedSize = 33 * textScaleFactor;
    } else if (longestYValue == 5) {
      leftReservedSize = 41 * textScaleFactor;
    } else if (longestYValue == 6) {
      leftReservedSize = 48 * textScaleFactor;
    } else if (longestYValue == 7) {
      leftReservedSize = 55 * textScaleFactor;
    } else if (longestYValue == 8) {
      leftReservedSize = 62 * textScaleFactor;
    } else {
      leftReservedSize = 66 * textScaleFactor;
    }

    // Calculate Vertical Line Step
    double verticalLineStep = (graphData.categories.length / 7).ceilToDouble();

    // Calculate Max Y Lines
    double maxYLines =
        (maxYValue / horizontalLineStep).ceilToDouble() * horizontalLineStep;

    return ChartDataModel(
      horizontalLineStep: horizontalLineStep,
      verticalLineStep: verticalLineStep,
      leftReservedSize: leftReservedSize,
      maxYLines: maxYLines,
    );
  }

  static List<LineChartBarData>? buildLineBarsData(GraphDataModel graphData) {
    List<LineChartBarData> lineBarsData = [];
    Map<GraphSeriesType, List<FlSpot>> spotListMap = {};

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
