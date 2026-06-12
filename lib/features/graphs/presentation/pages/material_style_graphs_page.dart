import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/pages/material/material_style_status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/tautulli_types.dart';
import '../../../../core/widgets/base/sensitive_text.dart';
import '../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../core/widgets/material/material_style_refresh_indicator.dart';
import '../../../../core/widgets/material/material_style_scaffold_with_inner_drawer.dart';
import '../../../../core/widgets/material/material_style_time_range_dialog.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/presentation/bloc/users_bloc.dart';
import '../bloc/graphs_bloc.dart';
import '../widgets/material/material_style_graph_tips_dialog.dart';
import '../widgets/material/material_style_media_type_graphs_tab.dart';
import '../widgets/material/material_style_play_totals_graphs_tab.dart';
import '../widgets/material/material_style_stream_type_graphs_tab.dart';

class MaterialStyleGraphsPage extends StatelessWidget {
  const MaterialStyleGraphsPage({super.key});

  static const routeName = '/graphs';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<GraphsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<UsersBloc>(),
        ),
      ],
      child: const MaterialStyleGraphsView(),
    );
  }
}

class MaterialStyleGraphsView extends StatefulWidget {
  const MaterialStyleGraphsView({super.key});

  @override
  State<MaterialStyleGraphsView> createState() => _MaterialStyleGraphsViewState();
}

class _MaterialStyleGraphsViewState extends State<MaterialStyleGraphsView> {
  late ServerModel _server;
  late int? _userId;
  late PlayMetricType _yAxis;
  late int _timeRange;
  late GraphsBloc _graphsBloc;
  late UsersBloc _usersBloc;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _graphsBloc = context.read<GraphsBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    _usersBloc = context.read<UsersBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _server = settingsState.appSettings.activeServer;
    _userId = _graphsBloc.state.userId ?? -1;
    _yAxis = settingsState.appSettings.graphYAxis;
    _timeRange = settingsState.appSettings.graphTimeRange;

    _graphsBloc.add(
      GraphsFetched(
        server: _server,
        yAxis: _yAxis,
        timeRange: _timeRange,
        userId: _userId,
        settingsBloc: _settingsBloc,
      ),
    );

    _usersBloc.add(
      UsersFetched(
        server: _server,
        settingsBloc: _settingsBloc,
      ),
    );

    if (!settingsState.appSettings.graphTipsShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        return showDialog(
          context: context,
          builder: (context) => const MaterialStyleGraphTipsDialog(),
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
          _server = state.appSettings.activeServer;

          _graphsBloc.add(
            GraphsFetched(
              server: _server,
              userId: _userId,
              yAxis: _yAxis,
              timeRange: _timeRange,
              settingsBloc: _settingsBloc,
            ),
          );
        }
      },
      child: MaterialStyleScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.graphs_title).tr(),
        actions: _server.id != null ? _appBarActions() : [],
        body: MaterialStylePageBody(
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;
              if (state.serverList.isEmpty) {
                return MaterialStyleStatusPage(
                  message: LocaleKeys.error_message_no_servers.tr(),
                  suggestion: LocaleKeys.error_suggestion_register_server.tr(),
                );
              }

              return DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          MaterialStyleRefreshIndicator(
                            onRefresh: () {
                              _graphsBloc.add(
                                GraphsFetched(
                                  server: _server,
                                  userId: _userId,
                                  yAxis: _yAxis,
                                  timeRange: _timeRange,
                                  freshFetch: true,
                                  settingsBloc: _settingsBloc,
                                ),
                              );

                              return Future.value();
                            },
                            child: const MaterialStyleMediaTypeGraphsTab(),
                          ),
                          MaterialStyleRefreshIndicator(
                            onRefresh: () {
                              _graphsBloc.add(
                                GraphsFetched(
                                  server: _server,
                                  userId: _userId,
                                  yAxis: _yAxis,
                                  timeRange: _timeRange,
                                  freshFetch: true,
                                  settingsBloc: _settingsBloc,
                                ),
                              );

                              return Future.value();
                            },
                            child: const MaterialStyleStreamTypeGraphsTab(),
                          ),
                          MaterialStyleRefreshIndicator(
                            onRefresh: () {
                              _graphsBloc.add(
                                GraphsFetched(
                                  server: _server,
                                  userId: _userId,
                                  yAxis: _yAxis,
                                  timeRange: _timeRange,
                                  freshFetch: true,
                                  settingsBloc: _settingsBloc,
                                ),
                              );

                              return Future.value();
                            },
                            child: const MaterialStylePlayTotalsGraphsTab(),
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
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _appBarActions() {
    return [
      BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: PopupMenuButton(
                  enabled: state.status == BlocStatus.success,
                  icon: FaIcon(
                    state.status == BlocStatus.failure ? FontAwesomeIcons.userSlash : FontAwesomeIcons.solidUser,
                    color: (_userId != -1 && _userId != null)
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    size: 20,
                  ),
                  tooltip: LocaleKeys.select_user_title.tr(),
                  onSelected: (value) {
                    setState(() {
                      _userId = value;
                    });

                    _graphsBloc.add(
                      GraphsFetched(
                        server: _server,
                        yAxis: _yAxis,
                        timeRange: _timeRange,
                        userId: _userId,
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
                    return state.users
                        .map(
                          (user) => PopupMenuItem(
                            value: user.userId,
                            child: BlocBuilder<SettingsBloc, SettingsState>(
                              builder: (context, state) {
                                state as SettingsSuccess;

                                return Text(
                                  user.friendlyName ?? '',
                                  style: TextStyle(
                                    color: _userId == user.userId!
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.onSurface,
                                  ),
                                ).sensitive();
                              },
                            ),
                          ),
                        )
                        .toList();
                  },
                ),
              ),
              if (state.status == BlocStatus.initial)
                Positioned(
                  bottom: 12,
                  right: 10,
                  child: SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      // Use BlocBuilder instead of setting _yAxis state to maintain current
      // selected tab.
      BlocBuilder<GraphsBloc, GraphsState>(
        builder: (context, state) {
          return PopupMenuButton(
            tooltip: LocaleKeys.y_axis_title.tr(),
            icon: FaIcon(
              _yAxis == PlayMetricType.plays ? FontAwesomeIcons.hashtag : FontAwesomeIcons.solidClock,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            onSelected: (PlayMetricType value) {
              _yAxis = value;

              _settingsBloc.add(
                SettingsUpdateGraphYAxis(_yAxis),
              );

              _graphsBloc.add(
                GraphsFetched(
                  server: _server,
                  userId: _userId,
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
                        color: _yAxis == PlayMetricType.plays
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const Gap(8),
                      Text(
                        LocaleKeys.play_count_title,
                        style: TextStyle(
                          color: _yAxis == PlayMetricType.plays
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
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
                        color: _yAxis == PlayMetricType.time
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const Gap(8),
                      Text(
                        LocaleKeys.play_time_title,
                        style: TextStyle(
                          color: _yAxis == PlayMetricType.time
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
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
                  icon: FaIcon(
                    FontAwesomeIcons.solidCalendarDays,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
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
                            server: _server,
                            userId: _userId,
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
                        builder: (context) => const MaterialStyleTimeRangeDialog(),
                      );

                      if (timeRange != _timeRange) {
                        _timeRange = timeRange;

                        _settingsBloc.add(
                          SettingsUpdateGraphTimeRange(_timeRange),
                        );

                        _graphsBloc.add(
                          GraphsFetched(
                            server: _server,
                            userId: _userId,
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
                            color: _timeRange == 7
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 14,
                        child: Text(
                          '14 ${LocaleKeys.days_title.tr()}',
                          style: TextStyle(
                            color: _timeRange == 14
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 30,
                        child: Text(
                          '30 ${LocaleKeys.days_title.tr()}',
                          style: TextStyle(
                            color: _timeRange == 30
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: -1,
                        child: Text(
                          'Custom',
                          style: TextStyle(
                            color: ![7, 14, 30].contains(_timeRange)
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
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
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Text(
                          _timeRange < 100 ? _timeRange.toString() : '99+',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _timeRange < 100 ? 10 : 8,
                            color: Theme.of(context).colorScheme.onPrimary,
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
