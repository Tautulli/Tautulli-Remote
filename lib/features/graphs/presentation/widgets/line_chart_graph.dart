import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/graph_data_helper.dart';
import '../../../../core/helpers/string_mapper_helper.dart';
import '../../domain/entities/graph_state.dart';
import '../../domain/entities/series_data.dart';
import 'graph_card.dart';

class LineChartGraph extends StatelessWidget {
  final GraphState graphState;
  final bool dataIsMediaType;

  const LineChartGraph({
    Key key,
    @required this.graphState,
    this.dataIsMediaType = true,
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

    // Calculate values for chart scale
    List<int> allYValues = [];
    for (var i = 0; i < notNullSeriesDataLists.length; i++) {
      allYValues.addAll(List.from(notNullSeriesDataLists[i].seriesData));
    }
    double maxYValue = allYValues.reduce(max).toDouble();

    double horizontalLineStep = GraphDataHelper.horizontalStep(
      maxYValue,
      graphState.yAxis,
    );

    double verticalLineStep =
        (graphState.graphData.categories.length / 7).ceilToDouble();

    double maxYLines =
        (maxYValue / horizontalLineStep).ceilToDouble() * horizontalLineStep;

    // Create spot data lists for mapping out the graph
    List<FlSpot> tvData = [];
    List<FlSpot> moviesData = [];
    List<FlSpot> musicData = [];
    List<FlSpot> liveData = [];
    List<FlSpot> directPlayData = [];
    List<FlSpot> directStreamData = [];
    List<FlSpot> transcodeData = [];

    // Put spot data lists in a list for easier indexing in a loop
    List spotList = dataIsMediaType
        ? [tvData, moviesData, musicData, liveData]
        : [directPlayData, directStreamData, transcodeData];

    for (var i = 0; i < graphState.graphData.categories.length; i++) {
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
      graphCurrentState: graphState.graphCurrentState,
      maxYLines: maxYLines,
      showTvLegend: dataIsMediaType && seriesDataLists[0] != null,
      showMoviesLegend: dataIsMediaType && seriesDataLists[1] != null,
      showMusicLegend: dataIsMediaType && seriesDataLists[2] != null,
      showLiveTvLegend: dataIsMediaType && seriesDataLists[3] != null,
      showDirectPlayLegend: !dataIsMediaType && seriesDataLists[0] != null,
      showDirectStreamLegend: !dataIsMediaType && seriesDataLists[1] != null,
      showTranscodeLegend: !dataIsMediaType && seriesDataLists[2] != null,
      chart: LineChart(
        LineChartData(
          titlesData: GraphDataHelper.buildFlTitlesData(
            yAxis: graphState.yAxis,
            categories: graphState.graphData.categories,
            leftTitlesInterval: horizontalLineStep,
            bottomTitlesInterval: verticalLineStep,
            bottomTitlesMargin: 8,
            getBottomTitles: (value) {
              if (value >= graphState.graphData.categories.length) {
                return '';
              }
              return GraphDataHelper.graphDate(
                graphState.graphData.categories[value.toInt()],
              );
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
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              tooltipBgColor: TautulliColorPalette.midnight.withOpacity(0.95),
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
                                '${GraphDataHelper.graphDate(graphState.graphData.categories[touchedSpots[0].x.toInt()], includeWeekDay: true)}\n\n',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        if (graphState.yAxis == 'plays')
                          TextSpan(
                            text:
                                '${StringMapperHelper.mapSeriesTypeToTitle(notNullSeriesDataLists[index].seriesType)}: ${touchedSpots[index].y.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: touchedSpots[index].bar.colors[0],
                            ),
                          ),
                        if (graphState.yAxis == 'duration')
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
            if (seriesDataLists[0] != null)
              LineChartBarData(
                isCurved: true,
                preventCurveOverShooting: true,
                spots: dataIsMediaType ? tvData : directPlayData,
                colors: [TautulliColorPalette.amber],
                dotData: FlDotData(
                  show: false,
                ),
              ),
            if (seriesDataLists[1] != null)
              LineChartBarData(
                isCurved: true,
                preventCurveOverShooting: true,
                spots: dataIsMediaType ? moviesData : directStreamData,
                colors: [TautulliColorPalette.not_white],
                dotData: FlDotData(
                  show: false,
                ),
              ),
            if (seriesDataLists[2] != null)
              LineChartBarData(
                isCurved: true,
                preventCurveOverShooting: true,
                spots: dataIsMediaType ? musicData : transcodeData,
                colors: [PlexColorPalette.cinnabar],
                dotData: FlDotData(
                  show: false,
                ),
              ),
            if (dataIsMediaType && seriesDataLists[3] != null)
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
