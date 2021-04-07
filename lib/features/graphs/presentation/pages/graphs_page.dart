import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_drawer_icon.dart';
import '../../../../core/widgets/double_tap_exit.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/graphs_bloc.dart';
import '../widgets/plays_by_date_graph.dart';

class GraphsPage extends StatelessWidget {
  const GraphsPage({Key key}) : super(key: key);

  static const routeName = '/graphs';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<GraphsBloc>(),
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
  SettingsBloc _settingsBloc;
  GraphsBloc _graphsBloc;
  String _tautulliId;

  @override
  void initState() {
    super.initState();
    _settingsBloc = context.read<SettingsBloc>();
    _graphsBloc = context.read<GraphsBloc>();

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

      _graphsBloc.add(
        GraphsFetch(
          tautulliId: _tautulliId,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphs'),
        leading: const AppDrawerIcon(),
      ),
      drawer: const AppDrawer(),
      body: DoubleTapExit(
        child: BlocBuilder<GraphsBloc, GraphsState>(
          builder: (context, state) {
            if (state is GraphsSuccess) {
              return PlaysByDateGraph(playsByDate: state.playsByDate);
            }
            if (state is GraphsFailure) {
              return const Text('FAILURE');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
