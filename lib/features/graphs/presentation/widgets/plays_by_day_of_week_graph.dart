import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tautulli_remote/core/helpers/string_mapper_helper.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/graph_data_helper.dart';
import '../../domain/entities/graph_state.dart';
import '../../domain/entities/series_data.dart';
import 'graph_card.dart';

class PlaysByDayOfWeekGraph extends StatelessWidget {
  final GraphState playsByDayOfWeek;

  const PlaysByDayOfWeekGraph({
    Key key,
    @required this.playsByDayOfWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract SeriesData items from graph data and place into a list for easier
    // indexing and access
    final tvSeriesData = playsByDayOfWeek.graphData.seriesDataList.firstWhere(
      (seriesData) => seriesData.seriesType == SeriesType.tv,
      orElse: () {
        return null;
      },
    );
    final moviesSeriesData =
        playsByDayOfWeek.graphData.seriesDataList.firstWhere(
      (seriesData) => seriesData.seriesType == SeriesType.movies,
      orElse: () {
        return null;
      },
    );
    final musicSeriesData =
        playsByDayOfWeek.graphData.seriesDataList.firstWhere(
      (seriesData) => seriesData.seriesType == SeriesType.music,
      orElse: () {
        return null;
      },
    );
    final liveSeriesData = playsByDayOfWeek.graphData.seriesDataList.firstWhere(
      (seriesData) => seriesData.seriesType == SeriesType.live,
      orElse: () {
        return null;
      },
    );

    List<SeriesData> seriesDataLists = [
      tvSeriesData,
      moviesSeriesData,
      musicSeriesData,
      liveSeriesData,
    ];

    // Create list of non null series data for use in the tooltip loop
    List<SeriesData> notNullSeriesDataLists = List.from(
      seriesDataLists.where((list) => list != null),
    );

    // Find the max y axis value
    double maxYValue = List<int>.generate(
        playsByDayOfWeek.graphData.categories.length, (index) {
      int value = 0;
      notNullSeriesDataLists.forEach((list) {
        value = value + list.seriesData[index];
      });
      return value;
    }).reduce(max).toDouble();

    double horizontalLineStep = GraphDataHelper.horizontalStep(
      maxYValue,
      playsByDayOfWeek.yAxis,
    );

    double verticalLineStep =
        (playsByDayOfWeek.graphData.categories.length / 7).ceilToDouble();

    double maxYLines =
        (maxYValue / horizontalLineStep).ceilToDouble() * horizontalLineStep;

    // Build out bars
    List<BarChartGroupData> barGroups = [];
    // For each day
    for (var i = 0; i < playsByDayOfWeek.graphData.categories.length; i++) {
      double tvValue =
          tvSeriesData != null ? tvSeriesData.seriesData[i].toDouble() : 0.0;
      double moviesValue = moviesSeriesData != null
          ? moviesSeriesData.seriesData[i].toDouble()
          : 0.0;
      double musicValue = musicSeriesData != null
          ? musicSeriesData.seriesData[i].toDouble()
          : 0.0;
      double liveValue = liveSeriesData != null
          ? liveSeriesData.seriesData[i].toDouble()
          : 0.0;

      double maxBarY = tvValue + moviesValue + musicValue + liveValue;

      double barStart = 0;
      List<BarChartRodStackItem> rodStackItems = [];

      if (liveValue > 0) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            liveValue + barStart,
            PlexColorPalette.curious_blue,
          ),
        );
        barStart = barStart + liveValue;
      }
      if (musicValue > 0) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            musicValue + barStart,
            PlexColorPalette.cinnabar,
          ),
        );
        barStart = barStart + musicValue;
      }
      if (moviesValue > 0) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            moviesValue + barStart,
            TautulliColorPalette.not_white,
          ),
        );
        barStart = barStart + moviesValue;
      }
      if (tvValue > 0) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            tvValue + barStart,
            PlexColorPalette.gamboge,
          ),
        );
        barStart = barStart + tvValue;
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: maxBarY,
              width: 20,
              colors: [Colors.transparent],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              rodStackItems: rodStackItems,
            ),
          ],
        ),
      );
    }

    return GraphCard(
      graphCurrentState: playsByDayOfWeek.graphCurrentState,
      showTvLegend: tvSeriesData != null,
      showMoviesLegend: moviesSeriesData != null,
      showMusicLegend: musicSeriesData != null,
      showLiveTvLegend: liveSeriesData != null,
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: playsByDayOfWeek.yAxis == 'duration' ? 50 : 22,
              interval: horizontalLineStep,
              getTitles: (value) {
                if (playsByDayOfWeek.yAxis == 'duration') {
                  return GraphDataHelper.graphDuration(value.toInt());
                }
                return value.toStringAsFixed(0);
              },
              getTextStyles: (value) {
                return const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                );
              },
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              rotateAngle: 320,
              margin: 8,
              interval: verticalLineStep,
              getTitles: (value) {
                return playsByDayOfWeek.graphData.categories[value.toInt()]
                    .substring(0, 3);
              },
              reservedSize: 30,
              getTextStyles: (value) {
                return const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                );
              },
            ),
          ),
          maxY: maxYLines,
          gridData: FlGridData(
            horizontalInterval: horizontalLineStep,
            verticalInterval: verticalLineStep,
            checkToShowHorizontalLine: (value) =>
                value % horizontalLineStep == 0,
            checkToShowVerticalLine: (value) => value % verticalLineStep == 0,
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.03),
            ),
          ),
          borderData: FlBorderData(
            border: const Border(
              top: BorderSide(
                width: 1,
                color: Colors.white24,
              ),
              bottom: BorderSide(
                width: 1,
                color: Colors.white24,
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              tooltipBgColor: TautulliColorPalette.midnight.withOpacity(0.95),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                List<SeriesData> validItems = List.from(
                  notNullSeriesDataLists
                      .where((element) => element.seriesData[groupIndex] > 0),
                );

                rod.rodStackItems.sort((a, b) => b.fromY.compareTo(a.fromY));

                List<TextSpan> textSpanList = [
                  TextSpan(
                    text:
                        '${playsByDayOfWeek.graphData.categories[groupIndex]}\n\n',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ];
                for (var i = 0; i < validItems.length; i++) {
                  String text = playsByDayOfWeek.yAxis == 'plays'
                      ? '${StringMapperHelper.mapSeriesTypeToTitle(validItems[i].seriesType)}: ${validItems[i].seriesData[groupIndex]}${i != validItems.length - 1 ? '\n' : ''}'
                      : '${StringMapperHelper.mapSeriesTypeToTitle(validItems[i].seriesType)}: ${GraphDataHelper.graphDuration(validItems[i].seriesData[groupIndex])}${i != validItems.length - 1 ? '\n' : ''}';

                  textSpanList.add(
                    TextSpan(
                      text: text,
                      style: TextStyle(
                        color: rod.rodStackItems[i].color,
                      ),
                    ),
                  );
                }

                return BarTooltipItem(
                  '',
                  const TextStyle(),
                  children: textSpanList,
                );
              },
            ),
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }
}
