import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tautulli_remote/core/types/graph_type.dart';

import '../bloc/graphs_bloc.dart';
import 'graph_card.dart';
import 'graph_heading.dart';

class MediaTypeGraphsTab extends StatelessWidget {
  const MediaTypeGraphsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphsBloc, GraphsState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: [
            GraphHeading(
              text: 'Daily Play Count by Media Type',
            ),
            GraphCard(
              yAxis: state.yAxis,
              graphType: GraphType.playsByDate,
              graph: state.graphs[GraphType.playsByDate]!,
            ),
          ],
        );
      },
    );
  }
}
