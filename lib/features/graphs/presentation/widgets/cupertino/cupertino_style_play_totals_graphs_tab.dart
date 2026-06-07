import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/types/graph_chart_type.dart';
import '../../../../../core/types/graph_type.dart';
import '../../../../../core/types/play_metric_type.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/graphs_bloc.dart';
import 'cupertino_style_graph_card.dart';
import 'cupertino_style_graph_heading.dart';

class CupertinoStylePlayTotalsGraphsTab extends StatelessWidget {
  const CupertinoStylePlayTotalsGraphsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphsBloc, GraphsState>(
      builder: (context, state) {
        return SliverPadding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                CupertinoStyleGraphHeading(
                  text: state.yAxis == PlayMetricType.plays
                      ? LocaleKeys.total_play_count_for_last_12_months_title.tr()
                      : LocaleKeys.total_play_time_for_last_12_months_title.tr(),
                ),
                CupertinoStyleGraphCard(
                  graphChartType: GraphChartType.bar,
                  yAxis: state.yAxis,
                  graphType: GraphType.playsPerMonth,
                  graph: state.graphs[GraphType.playsPerMonth]!,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
