import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/graph_data_helper.dart';
import '../../../../core/helpers/string_mapper_helper.dart';
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
    List<SeriesData> seriesDataLists = GraphDataHelper.parsedSeriesDataList(
      playsByDayOfWeek.graphData.seriesDataList,
    );

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
      double tvValue = seriesDataLists[0] != null
          ? seriesDataLists[0].seriesData[i].toDouble()
          : 0.0;
      double moviesValue = seriesDataLists[1] != null
          ? seriesDataLists[1].seriesData[i].toDouble()
          : 0.0;
      double musicValue = seriesDataLists[2] != null
          ? seriesDataLists[2].seriesData[i].toDouble()
          : 0.0;
      double liveValue = seriesDataLists[3] != null
          ? seriesDataLists[3].seriesData[i].toDouble()
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
      maxYLines: maxYLines,
      showTvLegend: seriesDataLists[0] != null,
      showMoviesLegend: seriesDataLists[1] != null,
      showMusicLegend: seriesDataLists[2] != null,
      showLiveTvLegend: seriesDataLists[3] != null,
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: GraphDataHelper.buildFlTitlesData(
            yAxis: playsByDayOfWeek.yAxis,
            categories: playsByDayOfWeek.graphData.categories,
            leftTitlesInterval: horizontalLineStep,
            bottomTitlesInterval: verticalLineStep,
            getBottomTitles: (value) {
              return playsByDayOfWeek.graphData.categories[value.toInt()]
                  .substring(0, 3);
            },
          ),
          maxY: maxYLines,
          gridData: GraphDataHelper.buildFlGridData(
            horizontalInterval: horizontalLineStep,
            verticalInterval: verticalLineStep,
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
                  notNullSeriesDataLists.where(
                    (element) => element.seriesData[groupIndex] > 0,
                  ),
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
