import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/types/graph_chart_type.dart';
import '../../../../core/types/graph_type.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/graphs_bloc.dart';
import 'graph_card.dart';
import 'graph_heading.dart';

class StreamTypeGraphsTab extends StatelessWidget {
  const StreamTypeGraphsTab({super.key});

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
                  ? LocaleKeys.daily_play_count_by_stream_type_title.tr()
                  : LocaleKeys.daily_play_time_by_stream_type_title.tr(),
            ),
            GraphCard(
              graphChartType: GraphChartType.line,
              yAxis: state.yAxis,
              graphType: GraphType.playsByStreamType,
              graph: state.graphs[GraphType.playsByStreamType]!,
            ),
            const Gap(18),
            GraphHeading(text: LocaleKeys.daily_concurrent_stream_count_by_stream_type_title.tr()),
            GraphCard(
              graphChartType: GraphChartType.line,
              yAxis: PlayMetricType.plays,
              graphType: GraphType.concurrentStreams,
              graph: state.graphs[GraphType.concurrentStreams]!,
            ),
            const Gap(18),
            GraphHeading(
              text: state.yAxis == PlayMetricType.plays ? LocaleKeys.play_count_by_source_resolution.tr() : LocaleKeys.play_time_by_source_resolution.tr(),
            ),
            GraphCard(
              graphChartType: GraphChartType.bar,
              yAxis: state.yAxis,
              graphType: GraphType.playsBySourceResolution,
              graph: state.graphs[GraphType.playsBySourceResolution]!,
            ),
            const Gap(18),
            GraphHeading(
              text: state.yAxis == PlayMetricType.plays ? LocaleKeys.play_count_by_stream_resolution.tr() : LocaleKeys.play_time_by_stream_resolution.tr(),
            ),
            GraphCard(
              graphChartType: GraphChartType.bar,
              yAxis: state.yAxis,
              graphType: GraphType.playsByStreamResolution,
              graph: state.graphs[GraphType.playsByStreamResolution]!,
            ),
            const Gap(18),
            GraphHeading(
              text:
                  state.yAxis == PlayMetricType.plays ? LocaleKeys.play_count_by_platform_stream_type.tr() : LocaleKeys.play_time_by_platform_stream_type.tr(),
            ),
            GraphCard(
              graphChartType: GraphChartType.bar,
              yAxis: state.yAxis,
              graphType: GraphType.streamTypeByTop10Platforms,
              graph: state.graphs[GraphType.streamTypeByTop10Platforms]!,
            ),
            const Gap(18),
            GraphHeading(
              text: state.yAxis == PlayMetricType.plays ? LocaleKeys.play_count_by_user_stream_type.tr() : LocaleKeys.play_time_by_user_stream_type.tr(),
            ),
            GraphCard(
              graphChartType: GraphChartType.bar,
              yAxis: state.yAxis,
              graphType: GraphType.streamTypeByTop10Users,
              graph: state.graphs[GraphType.streamTypeByTop10Users]!,
            ),
          ],
        );
      },
    );
  }
}
