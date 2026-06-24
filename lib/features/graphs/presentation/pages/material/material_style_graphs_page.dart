import 'package:badges/badges.dart' as badges;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/material/material_style_status_page.dart';
import '../../../../../core/types/tautulli_types.dart';
import '../../../../../core/widgets/material/bottom_sheets/material_style_time_range_bottom_sheet.dart';
import '../../../../../core/widgets/material/bottom_sheets/material_style_user_filter_bottom_sheet.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../core/widgets/material/material_style_refresh_indicator.dart';
import '../../../../../core/widgets/material/material_style_scaffold_with_inner_drawer.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/presentation/bloc/users_bloc.dart';
import '../../bloc/graphs_bloc.dart';
import '../../widgets/material/bottom_sheets/material_style_graphs_actions_bottom_sheet.dart';
import '../../widgets/material/bottom_sheets/material_style_y_axis_type_bottom_sheet.dart';
import '../../widgets/material/material_style_graph_tips_dialog.dart';
import '../../widgets/material/material_style_media_type_graphs_tab.dart';
import '../../widgets/material/material_style_play_totals_graphs_tab.dart';
import '../../widgets/material/material_style_stream_type_graphs_tab.dart';

class MaterialStyleGraphsPage extends StatelessWidget {
  const MaterialStyleGraphsPage({super.key});

  static const routeName = '/graphs';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<GraphsBloc>(param1: context.read<SettingsBloc>()),
        ),
        BlocProvider(
          create: (context) => di.sl<UsersBloc>(param1: context.read<SettingsBloc>()),
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
      ),
    );

    _usersBloc.add(
      UsersFetched(
        server: _server,
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
      IconButton(
        tooltip: LocaleKeys.time_range_title.tr(),
        icon: badges.Badge(
          badgeAnimation: const badges.BadgeAnimation.fade(toAnimate: false),
          position: badges.BadgePosition.bottomEnd(bottom: -8, end: -8),
          badgeStyle: badges.BadgeStyle(
            badgeColor: Theme.of(context).colorScheme.primary,
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          ),
          badgeContent: Text(
            _timeRange < 100 ? _timeRange.toString() : '99+',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 8,
              color: Colors.black,
            ),
          ),
          child: FaIcon(
            FontAwesomeIcons.solidCalendarDays,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        onPressed: () async {
          final result = await showModalBottomSheet<int>(
            context: context,
            isScrollControlled: true,
            builder: (_) => MaterialStyleTimeRangeBottomSheet(
              initialValue: _timeRange,
              hint: LocaleKeys.custom_time_range_dialog_content.tr(),
            ),
          );

          if (result != null && result != _timeRange) {
            setState(() {
              _timeRange = result;
            });

            _settingsBloc.add(SettingsUpdateGraphTimeRange(_timeRange));

            _graphsBloc.add(
              GraphsFetched(
                server: _server,
                userId: _userId,
                yAxis: _yAxis,
                timeRange: _timeRange,
                freshFetch: true,
              ),
            );
          }
        },
      ),
      IconButton(
        tooltip: LocaleKeys.graphs_action_title.tr(),
        icon: badges.Badge(
          showBadge: _userId != -1,
          badgeAnimation: const badges.BadgeAnimation.fade(toAnimate: false),
          position: badges.BadgePosition.bottomEnd(bottom: -5, end: -5),
          badgeStyle: badges.BadgeStyle(
            badgeColor: Theme.of(context).colorScheme.primary,
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          child: FaIcon(
            FontAwesomeIcons.sliders,
            color: Theme.of(context).colorScheme.onSurface,
            size: 20,
          ),
        ),
        onPressed: () async {
          final String? result = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: _usersBloc,
              child: MaterialStyleGraphsActionsBottomSheet(
                userId: _userId,
                yAxis: _yAxis,
              ),
            ),
          );

          if (!mounted) return;

          if (result == 'user') {
            final int? newUserId = await showModalBottomSheet<int>(
              context: context,
              isScrollControlled: true,
              builder: (_) => BlocProvider.value(
                value: _usersBloc,
                child: MaterialStyleUserFilterBottomSheet(
                  initialValue: _userId!,
                ),
              ),
            );

            if (newUserId != null && newUserId != _userId) {
              setState(() {
                _userId = newUserId;
              });

              _graphsBloc.add(
                GraphsFetched(
                  server: _server,
                  yAxis: _yAxis,
                  timeRange: _timeRange,
                  userId: _userId,
                  freshFetch: true,
                ),
              );
            }
          }

          if (!mounted) return;

          if (result == 'yAxis') {
            final PlayMetricType? yAxis = await showModalBottomSheet<PlayMetricType>(
              context: context,
              isScrollControlled: true,
              builder: (_) => MaterialStyleYAxisTypeBottomSheet(
                initialValue: _yAxis,
              ),
            );

            if (yAxis != null && yAxis != _yAxis) {
              setState(() {
                _yAxis = yAxis;
              });

              _settingsBloc.add(SettingsUpdateGraphYAxis(_yAxis));

              _graphsBloc.add(
                GraphsFetched(
                  server: _server,
                  yAxis: _yAxis,
                  timeRange: _timeRange,
                  userId: _userId,
                  freshFetch: true,
                ),
              );
            }
          }
        },
      ),
    ];
  }
}
