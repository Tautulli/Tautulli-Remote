import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/device_info/device_info.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/graph_helper.dart';
import '../../../../core/helpers/string_helper.dart';
import '../../../../core/types/graph_type.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/chart_data_model.dart';
import '../../data/models/graph_data_model.dart';
import '../../data/models/graph_series_data_model.dart';

class BarChartGraph extends StatelessWidget {
  final PlayMetricType yAxis;
  final GraphType graphType;
  final GraphDataModel graphData;
  final bool? isVertical;

  const BarChartGraph({
    super.key,
    required this.yAxis,
    required this.graphType,
    required this.graphData,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final SettingsSuccess settingsState = context.read<SettingsBloc>().state as SettingsSuccess;

    final ChartDataModel chartData = GraphHelper.buildBarChartDataModel(
      yAxis: yAxis,
      graphData: graphData,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
    );
    final List<BarChartGroupData>? barGroups = GraphHelper.buildBarGroups(
      graphData: graphData,
      screenWidth: MediaQuery.of(context).size.width,
    );
    int? lastTouchedIndex;

    return BarChart(
      BarChartData(
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
                    style: const TextStyle(
                      color: Colors.grey,
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
              reservedSize: isVertical == true ? 20 : 30,
              getTitlesWidget: (value, meta) {
                late String text;

                if (settingsState.appSettings.maskSensitiveInfo &&
                    [
                      GraphType.playsByTop10Users,
                      GraphType.streamTypeByTop10Users,
                    ].contains(graphType)) {
                  text = '${LocaleKeys.hidden_message.tr()}     ';
                } else if (graphType == GraphType.playsByDayOfWeek) {
                  text = graphData.categories[value.toInt()].substring(0, 3);
                } else if (graphType == GraphType.playsPerMonth) {
                  final categoryItems = graphData.categories[value.toInt()].split(' ');

                  text = '${categoryItems[0]} \'${categoryItems[1].substring(2)}   ';
                } else if ([
                  GraphType.playsByTop10Platforms,
                  GraphType.playsByTop10Users,
                  GraphType.streamTypeByTop10Platforms,
                  GraphType.streamTypeByTop10Users,
                ].contains(graphType)) {
                  if (graphData.categories[value.toInt()].length <= 6) {
                    text = '${graphData.categories[value.toInt()]}   ';
                  } else {
                    text = '${graphData.categories[value.toInt()].substring(0, 5)}...  ';
                  }
                } else {
                  text = graphData.categories[value.toInt()];
                }

                if (isVertical == true) {
                  return RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(-40 / 360),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
              interval: chartData.verticalLineStep,
            ),
          ),
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
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
        gridData: FlGridData(
          horizontalInterval: chartData.horizontalLineStep,
          verticalInterval: chartData.verticalLineStep,
          checkToShowHorizontalLine: (value) => value % chartData.horizontalLineStep == 0,
          checkToShowVerticalLine: (value) => value % chartData.verticalLineStep == 0,
          drawVerticalLine: true,
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.white.withOpacity(0.03),
          ),
          getDrawingHorizontalLine: (value) => FlLine(
            strokeWidth: 1,
            color: Colors.white24,
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipRoundedRadius: 12,
            tooltipBgColor: TautulliColorPalette.midnight.withOpacity(0.9),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              List<GraphSeriesDataModel> validItems = List.from(
                graphData.seriesDataList.where(
                  (seriesDataModel) => seriesDataModel.seriesData[groupIndex] > 0,
                ),
              );

              final sortedRodStackItems = rod.rodStackItems.reversed.toList();

              List<TextSpan> textSpanList = [];

              if (settingsState.appSettings.maskSensitiveInfo &&
                  [
                    GraphType.playsByTop10Users,
                    GraphType.streamTypeByTop10Users,
                  ].contains(graphType)) {
                textSpanList.add(
                  TextSpan(
                    text: '${LocaleKeys.hidden_message.tr()}\n\n',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                );
              } else {
                textSpanList.add(
                  TextSpan(
                    text: '${graphData.categories[groupIndex]}\n\n',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              for (var i = 0; i < validItems.length; i++) {
                if (yAxis == PlayMetricType.plays) {
                  textSpanList.add(
                    TextSpan(
                      text:
                          '${StringHelper.mapSeriesTypeToString(validItems[i].seriesType)}: ${validItems[i].seriesData[groupIndex]}',
                      style: TextStyle(
                        color: sortedRodStackItems[i].color,
                      ),
                    ),
                  );
                }
                if (yAxis == PlayMetricType.time) {
                  textSpanList.add(
                    TextSpan(
                      text:
                          '${StringHelper.mapSeriesTypeToString(validItems[i].seriesType)}: ${GraphHelper.graphDuration(validItems[i].seriesData[groupIndex])}',
                      style: TextStyle(
                        color: sortedRodStackItems[i].color,
                      ),
                    ),
                  );
                }

                if (i != validItems.length - 1) {
                  textSpanList.add(
                    const TextSpan(text: '\n'),
                  );
                }
              }

              return BarTooltipItem(
                '',
                const TextStyle(),
                children: textSpanList,
              );
            },
          ),
          touchCallback: (event, touchResponse) async {
            if (event is FlLongPressStart) {
              if (await di.sl<DeviceInfo>().platform == 'ios' && await di.sl<DeviceInfo>().version < 10) {
                HapticFeedback.vibrate();
              } else {
                HapticFeedback.heavyImpact();
              }

              lastTouchedIndex = touchResponse?.spot?.touchedBarGroupIndex;
            }
            if (event is FlLongPressMoveUpdate) {
              if (touchResponse?.spot?.touchedBarGroupIndex != lastTouchedIndex) {
                lastTouchedIndex = touchResponse?.spot?.touchedBarGroupIndex;

                if (touchResponse?.spot != null) {
                  if (await di.sl<DeviceInfo>().platform == 'ios' && await di.sl<DeviceInfo>().version < 10) {
                    HapticFeedback.vibrate();
                  } else {
                    HapticFeedback.selectionClick();
                  }
                }
              }
            }
          },
        ),
        barGroups: barGroups,
      ),
    );
  }
}
