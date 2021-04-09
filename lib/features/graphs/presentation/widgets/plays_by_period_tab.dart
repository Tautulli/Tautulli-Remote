import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/play_graphs_bloc.dart';
import 'graph_heading.dart';
import 'graphs_error_button.dart';
import 'plays_by_date_graph.dart';

class PlaysByPeriodTab extends StatefulWidget {
  PlaysByPeriodTab({Key key}) : super(key: key);

  @override
  _PlaysByPeriodTabState createState() => _PlaysByPeriodTabState();
}

class _PlaysByPeriodTabState extends State<PlaysByPeriodTab> {
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  PlayGraphsBloc _playGraphsBloc;
  String _tautulliId;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.read<SettingsBloc>();
    _playGraphsBloc = context.read<PlayGraphsBloc>();

    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      if (settingsState.lastSelectedServer != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == settingsState.lastSelectedServer) {
            lastSelectedServer = settingsState.lastSelectedServer;
            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (settingsState.serverList.isNotEmpty) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
        });
      } else {
        setState(() {
          _tautulliId = null;
        });
      }

      _playGraphsBloc.add(
        PlayGraphsFetch(
          tautulliId: _tautulliId,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayGraphsBloc, PlayGraphsState>(
      listener: (context, state) {
        if (state is PlayGraphsSuccess) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      builder: (context, state) {
        if (state is PlayGraphsFailure) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: ErrorMessage(
                      failure: state.failure,
                      message: state.message,
                      suggestion: state.suggestion,
                    ),
                  ),
                  GraphsErrorButton(
                    completer: _refreshCompleter,
                    failure: state.failure,
                    graphsAddedEvent: PlayGraphsFilter(
                      tautulliId: _tautulliId,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () {
            _playGraphsBloc.add(
              PlayGraphsFilter(
                tautulliId: _tautulliId,
              ),
            );
            return _refreshCompleter.future;
          },
          child: Scrollbar(
            child: ListView(
              children: [
                const GraphHeading(
                  graphHeading: 'Daily Play Count',
                ),
                BlocBuilder<PlayGraphsBloc, PlayGraphsState>(
                  builder: (context, state) {
                    if (state is PlayGraphsSuccess) {
                      return PlaysByDateGraph(
                        playsByDate: state.playsByDate,
                      );
                    }
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
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
