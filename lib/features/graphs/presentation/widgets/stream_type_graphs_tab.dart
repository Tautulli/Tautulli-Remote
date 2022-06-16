import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/graph_type.dart';
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
            GraphHeading(
              text: 'Daily Play Count by Stream Type',
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
