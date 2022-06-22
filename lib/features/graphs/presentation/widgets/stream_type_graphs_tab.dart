import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/graph_type.dart';
import '../../../../core/types/graph_y_axis.dart';
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
          padding: const EdgeInsets.all(8),
          children: [
            BlocBuilder<GraphsBloc, GraphsState>(
              builder: (context, state) {
                return GraphHeading(
                  text: state.yAxis == GraphYAxis.plays
                      ? LocaleKeys.daily_play_count_by_stream_type_title.tr()
                      : LocaleKeys.daily_play_duration_by_stream_type_title
                          .tr(),
                );
              },
            ),
            GraphCard(
              yAxis: state.yAxis,
              graphType: GraphType.playsByStreamType,
              graph: state.graphs[GraphType.playsByStreamType]!,
            ),
          ],
        );
      },
    );
  }
}
