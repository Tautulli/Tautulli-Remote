import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../../../core/helpers/quick_actions_helper.dart';
import '../../../../core/types/tautulli_types.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/graphs_bloc.dart';
import '../widgets/custom_time_range_dialog.dart';
import '../widgets/graph_tips_dialog.dart';
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
  final QuickActions quickActions = const QuickActions();
  late String _tautulliId;
  late PlayMetricType _yAxis;
  late int _timeRange;
  late GraphsBloc _graphsBloc;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    initalizeQuickActions(context, quickActions);

    _graphsBloc = context.read<GraphsBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _tautulliId = settingsState.appSettings.activeServer.tautulliId;
    _yAxis = settingsState.appSettings.graphYAxis;
    _timeRange = settingsState.appSettings.graphTimeRange;

    _graphsBloc.add(
      GraphsFetched(
        tautulliId: _tautulliId,
        yAxis: _yAxis,
        timeRange: _timeRange,
        settingsBloc: _settingsBloc,
      ),
    );

    if (!settingsState.appSettings.graphTipsShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        return showDialog(
          context: context,
          builder: (context) => const GraphTipsDialog(),
        );
      });
      _settingsBloc.add(const SettingsUpdateGraphTipsShown(true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) {
        if (previous is SettingsSuccess && current is SettingsSuccess) {
          if (previous.appSettings.activeServer != current.appSettings.activeServer) {
            return true;
          }
        }
        return false;
      },
      listener: (ctx, state) {
        if (state is SettingsSuccess) {
          _tautulliId = state.appSettings.activeServer.tautulliId;

          _graphsBloc.add(
            GraphsFetched(
              tautulliId: _tautulliId,
              yAxis: _yAxis,
              timeRange: _timeRange,
              settingsBloc: _settingsBloc,
            ),
          );
        }
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.graphs_title).tr(),
        actions: _appBarActions(),
        body: PageBody(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ThemedRefreshIndicator(
                        onRefresh: () {
                          _graphsBloc.add(
                            GraphsFetched(
                              tautulliId: _tautulliId,
                              yAxis: _yAxis,
                              timeRange: _timeRange,
                              freshFetch: true,
                              settingsBloc: _settingsBloc,
                            ),
                          );

                          return Future.value();
                        },
                        child: const MediaTypeGraphsTab(),
                      ),
                      ThemedRefreshIndicator(
                        onRefresh: () {
                          _graphsBloc.add(
                            GraphsFetched(
                              tautulliId: _tautulliId,
                              yAxis: _yAxis,
                              timeRange: _timeRange,
                              freshFetch: true,
                              settingsBloc: _settingsBloc,
                            ),
                          );

                          return Future.value();
                        },
                        child: const StreamTypeGraphsTab(),
                      ),
                      ThemedRefreshIndicator(
                        onRefresh: () {
                          _graphsBloc.add(
                            GraphsFetched(
                              tautulliId: _tautulliId,
                              yAxis: _yAxis,
                              timeRange: _timeRange,
                              freshFetch: true,
                              settingsBloc: _settingsBloc,
                            ),
                          );

                          return Future.value();
                        },
                        child: const PlayTotalsGraphsTab(),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  tabs: [
                    Tab(
                      child: const Text(
                        LocaleKeys.media_type_title,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ).tr(),
                    ),
                    Tab(
                      child: const Text(
                        LocaleKeys.stream_type_title,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ).tr(),
                    ),
                    Tab(
                      child: const Text(
                        LocaleKeys.play_totals_title,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ).tr(),
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

  List<Widget> _appBarActions() {
    return [
      // Use BlocBuilder instead of setting _yAxis state to maintain current
      // selected tab.
      BlocBuilder<GraphsBloc, GraphsState>(
        builder: (context, state) {
          return PopupMenuButton(
            tooltip: LocaleKeys.y_axis_title.tr(),
            icon: FaIcon(
              _yAxis == PlayMetricType.plays ? FontAwesomeIcons.hashtag : FontAwesomeIcons.solidClock,
              size: 20,
            ),
            onSelected: (PlayMetricType value) {
              _yAxis = value;

              _settingsBloc.add(
                SettingsUpdateGraphYAxis(_yAxis),
              );

              _graphsBloc.add(
                GraphsFetched(
                  tautulliId: _tautulliId,
                  yAxis: _yAxis,
                  timeRange: _timeRange,
                  freshFetch: true,
                  settingsBloc: _settingsBloc,
                ),
              );
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: PlayMetricType.plays,
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.hashtag,
                        size: 20,
                        color: _yAxis == PlayMetricType.plays ? Theme.of(context).colorScheme.secondary : null,
                      ),
                      const Gap(8),
                      Text(
                        LocaleKeys.play_count_title,
                        style: TextStyle(
                          color: _yAxis == PlayMetricType.plays ? Theme.of(context).colorScheme.secondary : null,
                        ),
                      ).tr(),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: PlayMetricType.time,
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidClock,
                        size: 20,
                        color: _yAxis == PlayMetricType.time ? Theme.of(context).colorScheme.secondary : null,
                      ),
                      const Gap(8),
                      Text(
                        LocaleKeys.play_time_title,
                        style: TextStyle(
                          color: _yAxis == PlayMetricType.time ? Theme.of(context).colorScheme.secondary : null,
                        ),
                      ).tr(),
                    ],
                  ),
                ),
              ];
            },
          );
        },
      ),
      BlocBuilder<GraphsBloc, GraphsState>(
        builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: PopupMenuButton(
                  tooltip: LocaleKeys.time_range_title.tr(),
                  icon: const FaIcon(
                    FontAwesomeIcons.solidCalendarDays,
                    size: 20,
                  ),
                  onSelected: (int value) async {
                    if (value > 0) {
                      if (value != _timeRange) {
                        _timeRange = value;

                        _settingsBloc.add(
                          SettingsUpdateGraphTimeRange(_timeRange),
                        );

                        _graphsBloc.add(
                          GraphsFetched(
                            tautulliId: _tautulliId,
                            yAxis: _yAxis,
                            timeRange: _timeRange,
                            freshFetch: true,
                            settingsBloc: _settingsBloc,
                          ),
                        );
                      }
                    } else {
                      final int timeRange = await showDialog(
                        context: context,
                        builder: (context) => const CustomTimeRangeDialog(),
                      );

                      if (timeRange != _timeRange) {
                        _timeRange = timeRange;

                        _settingsBloc.add(
                          SettingsUpdateGraphTimeRange(_timeRange),
                        );

                        _graphsBloc.add(
                          GraphsFetched(
                            tautulliId: _tautulliId,
                            yAxis: _yAxis,
                            timeRange: _timeRange,
                            freshFetch: true,
                            settingsBloc: _settingsBloc,
                          ),
                        );
                      }
                    }
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 7,
                        child: Text(
                          '7 ${LocaleKeys.days_title.tr()}',
                          style: TextStyle(
                            color: _timeRange == 7 ? Theme.of(context).colorScheme.secondary : null,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 14,
                        child: Text(
                          '14 ${LocaleKeys.days_title.tr()}',
                          style: TextStyle(
                            color: _timeRange == 14 ? Theme.of(context).colorScheme.secondary : null,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 30,
                        child: Text(
                          '30 ${LocaleKeys.days_title.tr()}',
                          style: TextStyle(
                            color: _timeRange == 30 ? Theme.of(context).colorScheme.secondary : null,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: -1,
                        child: Text(
                          'Custom',
                          style: TextStyle(
                            color: ![7, 14, 30].contains(_timeRange) ? Theme.of(context).colorScheme.secondary : null,
                          ),
                        ),
                      ),
                    ];
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 18,
                      width: 18,
                      color: Theme.of(context).colorScheme.secondary,
                      child: Center(
                        child: Text(
                          _timeRange < 100 ? _timeRange.toString() : '99+',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _timeRange < 100 ? 10 : 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ];
  }
}
