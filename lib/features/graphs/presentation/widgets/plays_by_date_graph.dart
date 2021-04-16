import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/graph_data_helper.dart';
import '../../../../core/helpers/string_mapper_helper.dart';
import '../../domain/entities/graph_state.dart';
import '../../domain/entities/series_data.dart';
import 'graph_card.dart';

class PlaysByDateGraph extends StatelessWidget {
  final GraphState playsByDate;

  const PlaysByDateGraph({
    Key key,
    @required this.playsByDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate values for chart scale
    double maxYValue = (List<int>.from(
            playsByDate.graphData.seriesDataList[0].seriesData +
                playsByDate.graphData.seriesDataList[1].seriesData +
                playsByDate.graphData.seriesDataList[2].seriesData))
        .reduce(max)
        .toDouble();

    double horizontalLineStep = GraphDataHelper.horizontalStep(
      maxYValue,
      playsByDate.yAxis,
    );

    double verticalLineStep =
        (playsByDate.graphData.categories.length / 7).ceilToDouble();

    double maxYLines =
        (maxYValue / horizontalLineStep).ceilToDouble() * horizontalLineStep;

    // Extract SeriesData items from graph data and place into a list for easier
    // indexing and access
    final tvSeriesData = playsByDate.graphData.seriesDataList.firstWhere(
      (seriesData) => seriesData.seriesType == SeriesType.tv,
      orElse: () {
        return null;
      },
    );
    final moviesSeriesData = playsByDate.graphData.seriesDataList.firstWhere(
      (seriesData) => seriesData.seriesType == SeriesType.movies,
      orElse: () {
        return null;
      },
    );
    final musicSeriesData = playsByDate.graphData.seriesDataList.firstWhere(
      (seriesData) => seriesData.seriesType == SeriesType.music,
      orElse: () {
        return null;
      },
    );
    final liveSeriesData = playsByDate.graphData.seriesDataList.firstWhere(
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

    // Create spot data lists for mapping out the graph
    List<FlSpot> tvData = [];
    List<FlSpot> moviesData = [];
    List<FlSpot> musicData = [];
    List<FlSpot> liveData = [];

    // Put spot data lists in a list for easier indexing in a loop
    List spotList = [tvData, moviesData, musicData, liveData];

    for (var i = 0; i < playsByDate.graphData.categories.length; i++) {
      for (var j = 0; j < seriesDataLists.length; j++) {
        if (seriesDataLists[j] != null) {
          spotList[j].add(
            FlSpot(
              i.toDouble(),
              seriesDataLists[j].seriesData[i].toDouble(),
            ),
          );
        }
      }
    }

    return GraphCard(
      graphCurrentState: playsByDate.graphCurrentState,
      showTvLegend: tvSeriesData != null,
      showMoviesLegend: moviesSeriesData != null,
      showMusicLegend: musicSeriesData != null,
      showLiveTvLegend: liveSeriesData != null,
      chart: maxYLines < 1 || maxYLines.isNaN
          ? const Center(
              child: Text(
                'No plays for the selected time range',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(
                    showTitles: true,
                    reservedSize: playsByDate.yAxis == 'duration' ? 50 : 22,
                    interval: horizontalLineStep,
                    getTitles: (value) {
                      if (playsByDate.yAxis == 'duration') {
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
                      if (value >= playsByDate.graphData.categories.length) {
                        return '';
                      }
                      return GraphDataHelper.graphDate(
                        playsByDate.graphData.categories[value.toInt()],
                      );
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
                  checkToShowVerticalLine: (value) =>
                      value % verticalLineStep == 0,
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
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    tooltipBgColor:
                        TautulliColorPalette.midnight.withOpacity(0.95),
                    getTooltipItems: (touchedSpots) {
                      touchedSpots.sort(
                        (a, b) => a.barIndex.compareTo(b.barIndex),
                      );

                      return List.generate(
                        notNullSeriesDataLists.length,
                        (index) {
                          return LineTooltipItem(
                            '',
                            const TextStyle(),
                            children: [
                              if (index == 0)
                                TextSpan(
                                  text:
                                      '${GraphDataHelper.graphDate(playsByDate.graphData.categories[touchedSpots[0].x.toInt()], includeWeekDay: true)}\n\n',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              if (playsByDate.yAxis == 'plays')
                                TextSpan(
                                  text:
                                      '${StringMapperHelper.mapSeriesTypeToTitle(notNullSeriesDataLists[index].seriesType)}: ${touchedSpots[index].y.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: touchedSpots[index].bar.colors[0],
                                  ),
                                ),
                              if (playsByDate.yAxis == 'duration')
                                TextSpan(
                                  text:
                                      '${StringMapperHelper.mapSeriesTypeToTitle(notNullSeriesDataLists[index].seriesType)}: ${GraphDataHelper.graphDuration(touchedSpots[index].y.toInt())}',
                                  style: TextStyle(
                                    color: touchedSpots[index].bar.colors[0],
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  getTouchedSpotIndicator: (barData, spotIndexes) {
                    return [
                      TouchedSpotIndicatorData(
                        FlLine(
                          color: Colors.transparent,
                        ),
                        FlDotData(
                          getDotPainter: (flSpot, _double, data, _int) =>
                              FlDotCirclePainter(
                            color: barData.colors.first,
                            strokeColor: barData.colors.first,
                            radius: 5,
                          ),
                        ),
                      ),
                    ];
                  },
                ),
                lineBarsData: [
                  if (tvSeriesData != null)
                    LineChartBarData(
                      isCurved: true,
                      preventCurveOverShooting: true,
                      spots: tvData,
                      colors: [TautulliColorPalette.amber],
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                  if (moviesSeriesData != null)
                    LineChartBarData(
                      isCurved: true,
                      preventCurveOverShooting: true,
                      spots: moviesData,
                      colors: [TautulliColorPalette.not_white],
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                  if (musicSeriesData != null)
                    LineChartBarData(
                      isCurved: true,
                      preventCurveOverShooting: true,
                      spots: musicData,
                      colors: [PlexColorPalette.cinnabar],
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                  if (liveSeriesData != null)
                    LineChartBarData(
                      isCurved: true,
                      preventCurveOverShooting: true,
                      spots: liveData,
                      colors: [PlexColorPalette.curious_blue],
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
