import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/types/graph_chart_type.dart';
import '../../../../../core/types/graph_type.dart';
import '../../../../../core/types/play_metric_type.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/graphs_bloc.dart';
import 'cupertino_style_graph_card.dart';
import 'cupertino_style_graph_heading.dart';

class CupertinoStyleMediaTypeGraphsTab extends StatelessWidget {
  const CupertinoStyleMediaTypeGraphsTab({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocBuilder<GraphsBloc, GraphsState>(
      builder: (context, state) {
        return SliverPadding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                CupertinoStyleGraphHeading(
                  text: state.yAxis == PlayMetricType.plays
                      ? LocaleKeys.daily_play_count_by_media_type_title.tr()
                      : LocaleKeys.daily_play_time_by_media_type_title.tr(),
                ),
                CupertinoStyleGraphCard(
                  graphChartType: GraphChartType.line,
                  yAxis: state.yAxis,
                  graphType: GraphType.playsByDate,
                  graph: state.graphs[GraphType.playsByDate]!,
                ),
                const Gap(18),
                CupertinoStyleGraphHeading(
                  text: state.yAxis == PlayMetricType.plays
                      ? LocaleKeys.play_count_by_day_of_the_week.tr()
                      : LocaleKeys.play_time_by_day_of_the_week.tr(),
                ),
                CupertinoStyleGraphCard(
                  graphChartType: GraphChartType.bar,
                  yAxis: state.yAxis,
                  graphType: GraphType.playsByDayOfWeek,
                  graph: state.graphs[GraphType.playsByDayOfWeek]!,
                ),
                const Gap(18),
                CupertinoStyleGraphHeading(
                  text: state.yAxis == PlayMetricType.plays
                      ? LocaleKeys.play_count_by_hour_of_the_day.tr()
                      : LocaleKeys.play_time_by_hour_of_the_day.tr(),
                ),
                CupertinoStyleGraphCard(
                  graphChartType: GraphChartType.bar,
                  yAxis: state.yAxis,
                  graphType: GraphType.playsByHourOfDay,
                  graph: state.graphs[GraphType.playsByHourOfDay]!,
                  isVertical: true,
                ),
                const Gap(18),
                CupertinoStyleGraphHeading(
                  text: state.yAxis == PlayMetricType.plays
                      ? LocaleKeys.play_count_by_top_10_platforms.tr()
                      : LocaleKeys.play_time_by_top_10_platforms.tr(),
                ),
                CupertinoStyleGraphCard(
                  graphChartType: GraphChartType.bar,
                  yAxis: state.yAxis,
                  graphType: GraphType.playsByTop10Platforms,
                  graph: state.graphs[GraphType.playsByTop10Platforms]!,
                ),
                const Gap(18),
                CupertinoStyleGraphHeading(
                  text: state.yAxis == PlayMetricType.plays
                      ? LocaleKeys.play_count_by_top_10_users.tr()
                      : LocaleKeys.play_time_by_top_10_users.tr(),
                ),
                CupertinoStyleGraphCard(
                  graphChartType: GraphChartType.bar,
                  yAxis: state.yAxis,
                  graphType: GraphType.playsByTop10Users,
                  graph: state.graphs[GraphType.playsByTop10Users]!,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
