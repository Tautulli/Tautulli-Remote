import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/device_info/device_info.dart';
import '../../../../core/helpers/graph_helper.dart';
import '../../../../core/helpers/string_helper.dart';
import '../../../../core/helpers/theme_helper.dart';
import '../../../../core/types/tautulli_types.dart';
import '../../../../dependency_injection.dart' as di;
import '../../data/models/chart_data_model.dart';
import '../../data/models/graph_data_model.dart';

class LineChartGraph extends StatelessWidget {
  final PlayMetricType yAxis;
  final GraphDataModel graphData;

  const LineChartGraph({
    super.key,
    required this.yAxis,
    required this.graphData,
  });

  @override
  Widget build(BuildContext context) {
    final ChartDataModel chartData = GraphHelper.buildLineChartDataModel(
      yAxis: yAxis,
      graphData: graphData,
      textScaleFactor: MediaQuery.of(context).textScaler.scale(1),
    );
    final List<LineChartBarData>? lineBarsData = GraphHelper.buildLineBarsData(
      context: context,
      graphData: graphData,
    );
    int? lastTouchedIndex;

    return LineChart(
      LineChartData(
        maxY: chartData.maxYLines,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: chartData.leftReservedSize,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    yAxis == PlayMetricType.time
                        ? GraphHelper.graphDuration(
                            value.toInt(),
                            useDays: false,
                          )
                        : value.toStringAsFixed(0),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                );
              },
              interval: chartData.horizontalLineStep,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                // Do not display the last column title
                if (value == graphData.categories.length - 1) {
                  return const SizedBox(height: 0, width: 0);
                }

                return Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 12,
                  ),
                  child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(-40 / 360),
                    child: Text(
                      GraphHelper.graphDate(graphData.categories[value.toInt()]),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
              interval: chartData.verticalLineStep,
            ),
          ),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
        ),
        borderData: FlBorderData(
          border: Border(
            top: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.outline,
            ),
            bottom: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        gridData: FlGridData(
          horizontalInterval: chartData.horizontalLineStep,
          verticalInterval: chartData.verticalLineStep,
          checkToShowHorizontalLine: (value) => value % chartData.horizontalLineStep == 0,
          checkToShowVerticalLine: (value) => value % chartData.verticalLineStep == 0,
          drawVerticalLine: true,
          getDrawingVerticalLine: (value) => FlLine(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
          getDrawingHorizontalLine: (value) => FlLine(
            strokeWidth: 1,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipRoundedRadius: 12,
            getTooltipColor: (touchedSpot) => ThemeHelper.darkenedColor(Theme.of(context).colorScheme.surface).withOpacity(0.98),
            getTooltipItems: (touchedSpots) {
              touchedSpots.sort(
                (a, b) => a.barIndex.compareTo(b.barIndex),
              );

              return List.generate(
                graphData.seriesDataList.length,
                (index) => LineTooltipItem(
                  '',
                  const TextStyle(),
                  children: [
                    if (index == 0)
                      TextSpan(
                        text: '${GraphHelper.graphDate(graphData.categories[touchedSpots[0].x.toInt()], includeWeekDay: true)}\n\n',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (yAxis == PlayMetricType.plays)
                      TextSpan(
                        text: '${StringHelper.mapSeriesTypeToString(graphData.seriesDataList[index].seriesType)}: ${touchedSpots[index].y.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: touchedSpots[index].bar.color,
                        ),
                      ),
                    if (yAxis == PlayMetricType.time)
                      TextSpan(
                        text:
                            '${StringHelper.mapSeriesTypeToString(graphData.seriesDataList[index].seriesType)}: ${GraphHelper.graphDuration(touchedSpots[index].y.toInt())}',
                        style: TextStyle(
                          color: touchedSpots[index].bar.color,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map(
              (spotIndex) {
                return TouchedSpotIndicatorData(
                  const FlLine(color: Colors.transparent, strokeWidth: 1.0),
                  FlDotData(
                    getDotPainter: (flSpot, _, data, __) => FlDotCirclePainter(
                      color: barData.color!,
                      strokeColor: barData.color!,
                      radius: 5,
                    ),
                  ),
                );
              },
            ).toList();
          },
          touchCallback: (event, touchResponse) async {
            if (event is FlLongPressStart) {
              if (di.sl<DeviceInfo>().platform == 'ios' && await di.sl<DeviceInfo>().version < 10) {
                HapticFeedback.vibrate();
              } else {
                HapticFeedback.heavyImpact();
              }

              lastTouchedIndex = touchResponse?.lineBarSpots?[0].spotIndex;
            }
            if (event is FlLongPressMoveUpdate) {
              if (touchResponse?.lineBarSpots?[0].spotIndex != lastTouchedIndex) {
                lastTouchedIndex = touchResponse?.lineBarSpots?[0].spotIndex;

                if (touchResponse?.lineBarSpots?[0] != null) {
                  if (di.sl<DeviceInfo>().platform == 'ios' && await di.sl<DeviceInfo>().version < 10) {
                    HapticFeedback.vibrate();
                  } else {
                    HapticFeedback.selectionClick();
                  }
                }
              }
            }
          },
        ),
        lineBarsData: lineBarsData ?? [],
      ),
    );
  }
}
