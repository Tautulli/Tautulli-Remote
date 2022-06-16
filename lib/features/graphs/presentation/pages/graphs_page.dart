import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/tautulli_types.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/graphs_bloc.dart';
import '../widgets/media_type_graphs_tab.dart';
import '../widgets/play_totals_graphs_tab.dart';
import '../widgets/stream_type_graphs_tab.dart';

class GraphsPage extends StatelessWidget {
  const GraphsPage({super.key});

  static const routeName = '/graphs';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<GraphsBloc>(),
      child: const GraphsView(),
    );
  }
}

class GraphsView extends StatefulWidget {
  const GraphsView({super.key});

  @override
  State<GraphsView> createState() => _GraphsViewState();
}

class _GraphsViewState extends State<GraphsView> {
  late String _tautulliId;
  late GraphYAxis _yAxis;
  late GraphsBloc _graphsBloc;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _graphsBloc = context.read<GraphsBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _tautulliId = settingsState.appSettings.activeServer.tautulliId;
    _yAxis = _graphsBloc.state.yAxis;

    _graphsBloc.add(
      GraphsFetched(
        tautulliId: _tautulliId,
        yAxis: _yAxis,
        settingsBloc: _settingsBloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) {
        if (previous is SettingsSuccess && current is SettingsSuccess) {
          if (previous.appSettings.activeServer !=
              current.appSettings.activeServer) {
            return true;
          }
        }
        return false;
      },
      listener: (ctx, state) {
        if (state is SettingsSuccess) {
          _tautulliId = state.appSettings.activeServer.tautulliId;
          _yAxis = GraphYAxis.plays;

          _graphsBloc.add(
            GraphsFetched(
              tautulliId: _tautulliId,
              yAxis: _yAxis,
              settingsBloc: _settingsBloc,
            ),
          );
        }
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.graphs_title).tr(),
        body: PageBody(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      MediaTypeGraphsTab(),
                      StreamTypeGraphsTab(),
                      PlayTotalsGraphsTab(),
                    ],
                  ),
                ),
                TabBar(
                  tabs: [
                    Tab(
                      child: const Text(LocaleKeys.media_type_title).tr(),
                    ),
                    Tab(
                      child: const Text(LocaleKeys.stream_type_title).tr(),
                    ),
                    Tab(
                      child: const Text(LocaleKeys.play_totals_title).tr(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
