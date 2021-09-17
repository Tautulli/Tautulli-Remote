// @dart=2.9

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../features/graphs/domain/entities/series_data.dart';

class GraphDataHelper {
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

  static double horizontalStep(double maxYValue, String yAxisType) {
    if (yAxisType == 'duration') {
      List<double> bins = [1800, 3600, 10800, 21600];

      double durationBin;

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

      return durationBin / 6;
    }
    return (maxYValue / 5).ceilToDouble();
  }

  static List<SeriesData> parsedSeriesDataList(
    List<SeriesData> list, {
    bool dataIsMediaType = true,
  }) {
    if (dataIsMediaType) {
      final tvSeriesData = list.firstWhere(
        (seriesData) => seriesData.seriesType == SeriesType.tv,
        orElse: () {
          return null;
        },
      );
      final moviesSeriesData = list.firstWhere(
        (seriesData) => seriesData.seriesType == SeriesType.movies,
        orElse: () {
          return null;
        },
      );
      final musicSeriesData = list.firstWhere(
        (seriesData) => seriesData.seriesType == SeriesType.music,
        orElse: () {
          return null;
        },
      );
      final liveSeriesData = list.firstWhere(
        (seriesData) => seriesData.seriesType == SeriesType.live,
        orElse: () {
          return null;
        },
      );

      return <SeriesData>[
        tvSeriesData,
        moviesSeriesData,
        musicSeriesData,
        liveSeriesData,
      ];
    } else {
      final directPlaySeriesData = list.firstWhere(
        (seriesData) => seriesData.seriesType == SeriesType.direct_play,
        orElse: () {
          return null;
        },
      );
      final directStreamSeriesData = list.firstWhere(
        (seriesData) => seriesData.seriesType == SeriesType.direct_stream,
        orElse: () {
          return null;
        },
      );
      final transcodeSeriesData = list.firstWhere(
        (seriesData) => seriesData.seriesType == SeriesType.transcode,
        orElse: () {
          return null;
        },
      );

      return <SeriesData>[
        directPlaySeriesData,
        directStreamSeriesData,
        transcodeSeriesData,
      ];
    }
  }

  static FlTitlesData buildFlTitlesData({
    @required String yAxis,
    @required List<String> categories,
    @required double leftTitlesInterval,
    @required double bottomTitlesInterval,
    @required String Function(double) getBottomTitles,
    double bottomTitlesRotateAngle = 320,
    double bottomTitlesMargin = 6,
  }) {
    return FlTitlesData(
      leftTitles: SideTitles(
        showTitles: true,
        reservedSize: yAxis == 'duration' ? 50 : 22,
        interval: leftTitlesInterval,
        getTitles: (value) {
          if (yAxis == 'duration') {
            return graphDuration(value.toInt(), useDays: false);
          }
          return value.toStringAsFixed(0);
        },
        getTextStyles: (context, value) {
          return const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          );
        },
      ),
      bottomTitles: SideTitles(
        showTitles: true,
        rotateAngle: bottomTitlesRotateAngle,
        margin: bottomTitlesMargin,
        interval: bottomTitlesInterval,
        getTitles: getBottomTitles,
        reservedSize: 30,
        getTextStyles: (context, value) {
          return const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          );
        },
      ),
      rightTitles: SideTitles(),
      topTitles: SideTitles(),
    );
  }

  static FlGridData buildFlGridData({
    @required double horizontalInterval,
    @required double verticalInterval,
  }) {
    return FlGridData(
      horizontalInterval: horizontalInterval,
      verticalInterval: verticalInterval,
      checkToShowHorizontalLine: (value) => value % horizontalInterval == 0,
      checkToShowVerticalLine: (value) => value % verticalInterval == 0,
      drawVerticalLine: true,
      getDrawingVerticalLine: (value) => FlLine(
        color: Colors.white.withOpacity(0.03),
      ),
    );
  }
}
