import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/graph_data_helper.dart';
import '../../../../core/helpers/string_mapper_helper.dart';
import '../../domain/entities/graph_state.dart';
import '../../domain/entities/series_data.dart';
import 'graph_card.dart';

class BarChartGraph extends StatelessWidget {
  final GraphState graphState;
  final bool dataIsMediaType;
  final double barWidth;
  final double barBorderRadius;
  final double bottomTitlesRotateAngle;
  final double bottomTitlesMargin;
  final bool maskSensitiveInfo;
  final double spaceAboveLegend;

  const BarChartGraph({
    Key key,
    @required this.graphState,
    this.dataIsMediaType = true,
    this.barWidth = 20,
    this.barBorderRadius = 4,
    this.bottomTitlesRotateAngle,
    this.bottomTitlesMargin = 4,
    this.maskSensitiveInfo = false,
    this.spaceAboveLegend = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract SeriesData items from graph data and place into a list for easier
    // indexing and access
    List<SeriesData> seriesDataLists = GraphDataHelper.parsedSeriesDataList(
      graphState.graphData.seriesDataList,
      dataIsMediaType: dataIsMediaType,
    );

    // Create list of non null series data for use in the tooltip loop
    List<SeriesData> notNullSeriesDataLists = List.from(
      seriesDataLists.where((list) => list != null),
    );

    // Find the max y axis value
    double maxYValue =
        List<int>.generate(graphState.graphData.categories.length, (index) {
      int value = 0;
      notNullSeriesDataLists.forEach((list) {
        value = value + list.seriesData[index];
      });
      return value;
    }).reduce(max).toDouble();

    double horizontalLineStep = GraphDataHelper.horizontalStep(
      maxYValue,
      graphState.yAxis,
    );

    double verticalLineStep =
        (graphState.graphData.categories.length / 7).ceilToDouble();

    double maxYLines =
        (maxYValue / horizontalLineStep).ceilToDouble() * horizontalLineStep;

    // Build out bars
    List<BarChartGroupData> barGroups = [];
    // For each day
    for (var i = 0; i < graphState.graphData.categories.length; i++) {
      double tvOrDirectPlayValue = seriesDataLists[0] != null
          ? seriesDataLists[0].seriesData[i].toDouble()
          : 0.0;
      double moviesOrDirectStreamValue = seriesDataLists[1] != null
          ? seriesDataLists[1].seriesData[i].toDouble()
          : 0.0;
      double musicOrTranscodeValue = seriesDataLists[2] != null
          ? seriesDataLists[2].seriesData[i].toDouble()
          : 0.0;
      double liveValue = dataIsMediaType && seriesDataLists[3] != null
          ? seriesDataLists[3].seriesData[i].toDouble()
          : 0.0;

      double maxBarY = tvOrDirectPlayValue +
          moviesOrDirectStreamValue +
          musicOrTranscodeValue +
          liveValue;

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
      if (musicOrTranscodeValue > 0) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            musicOrTranscodeValue + barStart,
            PlexColorPalette.cinnabar,
          ),
        );
        barStart = barStart + musicOrTranscodeValue;
      }
      if (moviesOrDirectStreamValue > 0) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            moviesOrDirectStreamValue + barStart,
            TautulliColorPalette.not_white,
          ),
        );
        barStart = barStart + moviesOrDirectStreamValue;
      }
      if (tvOrDirectPlayValue > 0) {
        rodStackItems.add(
          BarChartRodStackItem(
            barStart,
            tvOrDirectPlayValue + barStart,
            PlexColorPalette.gamboge,
          ),
        );
        barStart = barStart + tvOrDirectPlayValue;
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: maxBarY,
              width: barWidth,
              colors: [Colors.transparent],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(barBorderRadius),
                topRight: Radius.circular(barBorderRadius),
              ),
              rodStackItems: rodStackItems,
            ),
          ],
        ),
      );
    }

    return GraphCard(
      graphCurrentState: graphState.graphCurrentState,
      maxYLines: maxYLines,
      spaceAboveLegend: spaceAboveLegend,
      showTvLegend: dataIsMediaType && seriesDataLists[0] != null,
      showMoviesLegend: dataIsMediaType && seriesDataLists[1] != null,
      showMusicLegend: dataIsMediaType && seriesDataLists[2] != null,
      showLiveTvLegend: dataIsMediaType && seriesDataLists[3] != null,
      showDirectPlayLegend: !dataIsMediaType && seriesDataLists[0] != null,
      showDirectStreamLegend: !dataIsMediaType && seriesDataLists[1] != null,
      showTranscodeLegend: !dataIsMediaType && seriesDataLists[2] != null,
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: GraphDataHelper.buildFlTitlesData(
            yAxis: graphState.yAxis,
            categories: graphState.graphData.categories,
            leftTitlesInterval: horizontalLineStep,
            bottomTitlesInterval: verticalLineStep,
            bottomTitlesRotateAngle: bottomTitlesRotateAngle,
            bottomTitlesMargin: bottomTitlesMargin,
            getBottomTitles: (value) {
              if (value < graphState.graphData.categories.length) {
                if (maskSensitiveInfo &&
                    [
                      GraphType.playsByTop10Users,
                      GraphType.streamTypeByTop10Users,
                    ].contains(graphState.graphType)) {
                  return '*Hidden*';
                }

                if (graphState.graphType == GraphType.playsByDayOfWeek) {
                  return graphState.graphData.categories[value.toInt()]
                      .substring(0, 3);
                } else if ([
                  GraphType.playsByTop10Platforms,
                  GraphType.playsByTop10Users,
                  GraphType.streamTypeByTop10Platforms,
                  GraphType.streamTypeByTop10Users,
                ].contains(graphState.graphType)) {
                  if (graphState.graphData.categories[value.toInt()].length <=
                      6) {
                    return graphState.graphData.categories[value.toInt()];
                  } else {
                    return graphState.graphData.categories[value.toInt()]
                            .substring(0, 5) +
                        '...';
                  }
                }
                return graphState.graphData.categories[value.toInt()];
              }
              return '';
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
                    text: '${graphState.graphData.categories[groupIndex]}\n\n',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ];
                for (var i = 0; i < validItems.length; i++) {
                  String text = graphState.yAxis == 'plays'
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
