import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/graph_state.dart';
import '../bloc/play_totals_graphs_bloc.dart';
import 'bar_chart_graph.dart';
import 'graph_error_message.dart';
import 'graph_heading.dart';

class PlayTotalsTab extends StatefulWidget {
  final String tautulliId;
  // final int timeRange;
  final String yAxis;

  PlayTotalsTab({
    Key key,
    @required this.tautulliId,
    // @required this.timeRange,
    @required this.yAxis,
  }) : super(key: key);

  @override
  _PlayTotalsTabState createState() => _PlayTotalsTabState();
}

class _PlayTotalsTabState extends State<PlayTotalsTab> {
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  PlayTotalsGraphsBloc _playTotalsGraphsBloc;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.read<SettingsBloc>();
    _playTotalsGraphsBloc = context.read<PlayTotalsGraphsBloc>();

    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      _playTotalsGraphsBloc.add(
        PlayTotalsGraphsFetch(
          tautulliId: widget.tautulliId,
          // timeRange: widget.timeRange,
          yAxis: widget.yAxis,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayTotalsGraphsBloc, PlayTotalsGraphsState>(
      listener: (context, state) {
        if (state is PlayTotalsGraphsLoaded) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          color: Theme.of(context).accentColor,
          onRefresh: () {
            _playTotalsGraphsBloc.add(
              PlayTotalsGraphsFetch(
                tautulliId: widget.tautulliId,
                // timeRange: widget.timeRange,
                yAxis: widget.yAxis,
                settingsBloc: _settingsBloc,
              ),
            );
            return _refreshCompleter.future;
          },
          child: Scrollbar(
            child: ListView(
              children: [
                GraphHeading(
                  graphHeading:
                      'Total Play ${widget.yAxis == 'plays' ? 'Count' : 'Duration'} for Last 12 Months',
                ),
                (state is PlayTotalsGraphsLoaded &&
                        state.playsPerMonth.graphCurrentState !=
                            GraphCurrentState.failure &&
                        state.playsPerMonth.graphData != null &&
                        widget.yAxis == state.playsPerMonth.yAxis)
                    ? BarChartGraph(
                        graphState: state.playsPerMonth,
                        barWidth: 16,
                        bottomTitlesRotateAngle: 320,
                        bottomTitlesMargin: 12,
                        spaceAboveLegend: 8,
                      )
                    : _GraphLoadingOrFailed(
                        child: state is PlayTotalsGraphsLoaded &&
                                state.playsPerMonth.graphCurrentState ==
                                    GraphCurrentState.failure
                            ? GraphErrorMessage(
                                message: state.playsPerMonth.failureMessage,
                                suggestion:
                                    state.playsPerMonth.failureSuggestion,
                              )
                            : CircularProgressIndicator(
                                color: Theme.of(context).accentColor,
                              ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GraphLoadingOrFailed extends StatelessWidget {
  final Widget child;

  const _GraphLoadingOrFailed({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 275,
          color: TautulliColorPalette.gunmetal,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
