import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../domain/entities/graph_data.dart';

class PlaysByDateGraph extends StatelessWidget {
  final GraphData playsByDate;

  const PlaysByDateGraph({
    Key key,
    @required this.playsByDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    List<FlSpot> tvData = [];
    List<FlSpot> moviesData = [];
    List<FlSpot> musicData = [];
    for (var i = 0; i < playsByDate.categories.length; i++) {
      tvData.add(
        FlSpot(
          i.toDouble(),
          playsByDate.seriesDataList[0].seriesData[i].toDouble(),
        ),
      );
      moviesData.add(
        FlSpot(
          i.toDouble(),
          playsByDate.seriesDataList[1].seriesData[i].toDouble(),
        ),
      );
      musicData.add(
        FlSpot(
          i.toDouble(),
          playsByDate.seriesDataList[2].seriesData[i].toDouble(),
        ),
      );
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
                          interval: 5,
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
                          getTitles: (value) => 'Mar\n12',
                          // rotateAngle: -45,
                          // margin: 20,
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
                            return [
                              LineTooltipItem(
                                'TV: ${touchedSpots[0].y.toStringAsFixed(0)}',
                                const TextStyle(
                                  color: TautulliColorPalette.amber,
                                ),
                              ),
                              LineTooltipItem(
                                'Movies: ${touchedSpots[1].y.toStringAsFixed(0)}',
                                const TextStyle(
                                  color: TautulliColorPalette.not_white,
                                ),
                              ),
                              LineTooltipItem(
                                'Music: ${touchedSpots[2].y.toStringAsFixed(0)}',
                                const TextStyle(
                                  color: PlexColorPalette.cinnabar,
                                ),
                              ),
                            ];
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
                        LineChartBarData(
                          isCurved: true,
                          preventCurveOverShooting: true,
                          spots: tvData,
                          colors: [TautulliColorPalette.amber],
                          dotData: FlDotData(
                            show: false,
                          ),
                        ),
                        LineChartBarData(
                          isCurved: true,
                          preventCurveOverShooting: true,
                          spots: moviesData,
                          colors: [TautulliColorPalette.not_white],
                          dotData: FlDotData(
                            show: false,
                          ),
                        ),
                        LineChartBarData(
                          isCurved: true,
                          preventCurveOverShooting: true,
                          spots: musicData,
                          colors: [PlexColorPalette.cinnabar],
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
                    Row(
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.solidCircle,
                          color: TautulliColorPalette.amber,
                          size: 12,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text('TV'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.solidCircle,
                          color: TautulliColorPalette.not_white,
                          size: 12,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text('Movies'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.solidCircle,
                          color: PlexColorPalette.cinnabar,
                          size: 12,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text('Music'),
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
