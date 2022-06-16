import 'package:flutter/material.dart';
import 'package:tautulli_remote/core/types/graph_type.dart';
import 'package:tautulli_remote/core/types/tautulli_types.dart';
import 'package:tautulli_remote/features/graphs/data/models/graph_model.dart';
import 'package:tautulli_remote/features/graphs/presentation/widgets/graph_card_legend.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/bloc_status.dart';
import '../../data/models/graph_data_model.dart';
import 'line_chart_graph.dart';

class GraphCard extends StatelessWidget {
  final GraphYAxis yAxis;
  final GraphType graphType;
  final GraphModel graph;

  // final BlocStatus status;
  // final GraphDataModel? graphData;
  // final Failure? failure;
  // final String? message;
  // final String? suggestion;

  const GraphCard({
    super.key,
    required this.yAxis,
    required this.graphType,
    required this.graph,
    // required this.status,
    // this.graphData,
    // this.failure,
    // this.message,
    // this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 275,
        child: Builder(builder: (context) {
          if (graph.status == BlocStatus.failure) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (graph.failureMessage != null) Text(graph.failureMessage!),
                  if (graph.failureSuggestion != null)
                    Text(graph.failureSuggestion!),
                ],
              ),
            );
          }

          if (graph.graphDataModel == null &&
              graph.status != BlocStatus.initial) {
            return const Center(
              child: Text('No graph data provided'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: graph.graphDataModel != null
                      ? LineChartGraph(
                          yAxis: yAxis,
                          graphData: graph.graphDataModel!,
                        )
                      : null,
                ),
              ),
              if (graph.graphDataModel != null)
                GraphCardLegend(
                  graphData: graph.graphDataModel!,
                ),
              graph.status == BlocStatus.initial
                  ? LinearProgressIndicator(
                      backgroundColor: Theme.of(context).cardColor,
                    )
                  : const SizedBox(height: 4),
            ],
          );
        }),
      ),
    );
  }
}
