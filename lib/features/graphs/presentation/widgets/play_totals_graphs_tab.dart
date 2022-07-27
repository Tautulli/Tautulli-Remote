import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/graph_chart_type.dart';
import '../../../../core/types/graph_type.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/graphs_bloc.dart';
import 'graph_card.dart';
import 'graph_heading.dart';

class PlayTotalsGraphsTab extends StatelessWidget {
  const PlayTotalsGraphsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphsBloc, GraphsState>(
      builder: (context, state) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          children: [
            GraphHeading(
              text: state.yAxis == PlayMetricType.plays
                  ? LocaleKeys.total_play_count_for_last_12_months_title.tr()
                  : LocaleKeys.total_play_time_for_last_12_months_title.tr(),
            ),
            GraphCard(
              graphChartType: GraphChartType.bar,
              yAxis: state.yAxis,
              graphType: GraphType.playsPerMonth,
              graph: state.graphs[GraphType.playsPerMonth]!,
            ),
          ],
        );
      },
    );
  }
}
