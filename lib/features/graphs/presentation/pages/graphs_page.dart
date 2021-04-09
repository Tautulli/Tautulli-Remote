import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_drawer_icon.dart';
import '../../../../core/widgets/double_tap_exit.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/play_graphs_bloc.dart';
import '../widgets/plays_by_period_tab.dart';

class GraphsPage extends StatelessWidget {
  const GraphsPage({Key key}) : super(key: key);

  static const routeName = '/graphs';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PlayGraphsBloc>(),
      child: _GraphsPageContent(),
    );
  }
}

class _GraphsPageContent extends StatefulWidget {
  _GraphsPageContent({Key key}) : super(key: key);

  @override
  __GraphsPageContentState createState() => __GraphsPageContentState();
}

class __GraphsPageContentState extends State<_GraphsPageContent> {
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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Graphs'),
        leading: const AppDrawerIcon(),
      ),
      drawer: const AppDrawer(),
      body: DoubleTapExit(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                if (state is SettingsLoadSuccess) {
                  if (state.serverList.length > 1) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _tautulliId,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        items: state.serverList.map((server) {
                          return DropdownMenuItem(
                            child: ServerHeader(serverName: server.plexName),
                            value: server.tautulliId,
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != _tautulliId) {
                            setState(() {
                              _tautulliId = value;
                            });
                            _settingsBloc.add(
                              SettingsUpdateLastSelectedServer(
                                  tautulliId: _tautulliId),
                            );
                            _playGraphsBloc.add(
                              PlayGraphsFilter(
                                tautulliId: value,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                }
                return Container(height: 0, width: 0);
              },
            ),
            DefaultTabController(
              length: 2,
              child: Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          BlocProvider.value(
                            value: _playGraphsBloc,
                            child: PlaysByPeriodTab(),
                          ),
                          const Placeholder(),
                        ],
                      ),
                    ),
                    const TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          child: Text('Plays by Period'),
                        ),
                        Tab(
                          child: Text('Stream Info'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
