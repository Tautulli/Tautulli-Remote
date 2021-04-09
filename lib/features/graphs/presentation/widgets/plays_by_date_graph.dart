import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/string_mapper_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../domain/entities/graph_data.dart';
import '../../domain/entities/series_data.dart';

class PlaysByDateGraph extends StatelessWidget {
  final GraphData playsByDate;

  const PlaysByDateGraph({
    Key key,
    @required this.playsByDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate values for chart scale
    double largestPlayCount = (List<int>.from(
            playsByDate.seriesDataList[0].seriesData +
                playsByDate.seriesDataList[1].seriesData +
                playsByDate.seriesDataList[2].seriesData))
        .reduce(max)
        .toDouble();

    double horizontalLineStep = (largestPlayCount / 5).ceilToDouble();
    double verticalLineStep =
        (playsByDate.categories.length / 7).ceilToDouble();

    double maxYLines = (largestPlayCount / horizontalLineStep).ceilToDouble() *
        horizontalLineStep;

    // Extract SeriesData items from graph data and place into a list for easier
    // indexing and access
    final tvSeriesData = playsByDate.seriesDataList.firstWhere(
      (seriesData) => seriesData.seriesType == SeriesType.tv,
      orElse: () {
        return null;
      },
    );
    final moviesSeriesData = playsByDate.seriesDataList.firstWhere(
      (seriesData) => seriesData.seriesType == SeriesType.movies,
      orElse: () {
        return null;
      },
    );
    final musicSeriesData = playsByDate.seriesDataList.firstWhere(
      (seriesData) => seriesData.seriesType == SeriesType.music,
      orElse: () {
        return null;
      },
    );
    final liveSeriesData = playsByDate.seriesDataList.firstWhere(
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

    for (var i = 0; i < playsByDate.categories.length; i++) {
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

    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 275,
          color: TautulliColorPalette.gunmetal,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 4,
              bottom: 8,
              right: 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        leftTitles: SideTitles(
                          showTitles: true,
                          interval: horizontalLineStep,
                          getTextStyles: (value) {
                            return const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            );
                          },
                        ),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          interval: verticalLineStep,
                          getTitles: (value) {
                            return TimeFormatHelper.graphDate(
                                playsByDate.categories[value.toInt()]);
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
                                            '${TimeFormatHelper.graphDate(playsByDate.categories[touchedSpots[0].x.toInt()], includeWeekDay: true)}\n\n',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    TextSpan(
                                      text:
                                          '${StringMapperHelper.mapSeriesTypeToTitle(notNullSeriesDataLists[index].seriesType)}: ${touchedSpots[index].y.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        color:
                                            touchedSpots[index].bar.colors[0],
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (tvSeriesData != null)
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.solidCircle,
                            color: TautulliColorPalette.amber,
                            size: 12,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text('TV'),
                          ),
                          if (moviesSeriesData != null ||
                              musicSeriesData != null ||
                              liveSeriesData != null)
                            const SizedBox(width: 8),
                        ],
                      ),
                    if (moviesSeriesData != null)
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.solidCircle,
                            color: TautulliColorPalette.not_white,
                            size: 12,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text('Movies'),
                          ),
                          if (musicSeriesData != null || liveSeriesData != null)
                            const SizedBox(width: 8),
                        ],
                      ),
                    if (musicSeriesData != null)
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.solidCircle,
                            color: PlexColorPalette.cinnabar,
                            size: 12,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text('Music'),
                          ),
                          if (liveSeriesData != null) const SizedBox(width: 8),
                        ],
                      ),
                    if (liveSeriesData != null)
                      Row(
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.solidCircle,
                            color: PlexColorPalette.curious_blue,
                            size: 12,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text('Live TV'),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
