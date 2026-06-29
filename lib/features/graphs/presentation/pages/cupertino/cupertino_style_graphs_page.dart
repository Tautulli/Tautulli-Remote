import 'dart:async';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/types/play_metric_type.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../core/widgets/cupertino/bottom_sheets/cupertino_style_time_range_bottom_sheet.dart';
import '../../../../../core/widgets/cupertino/bottom_sheets/cupertino_style_user_filter_bottom_sheet.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/presentation/bloc/users_bloc.dart';
import '../../bloc/graphs_bloc.dart';
import '../../widgets/cupertino/dialogs/cupertino_style_graph_tips_dialog.dart';
import '../../widgets/cupertino/bottom_sheets/cupertino_style_graphs_actions_bottom_sheet.dart';
import '../../widgets/cupertino/cupertino_style_media_type_graphs_tab.dart';
import '../../widgets/cupertino/cupertino_style_play_totals_graphs_tab.dart';
import '../../widgets/cupertino/cupertino_style_stream_type_graphs_tab.dart';
import '../../widgets/cupertino/bottom_sheets/cupertino_style_y_axis_type_bottom_sheet.dart';

class CupertinoStyleGraphsPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleGraphsPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

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
      child: CupertinoStyleGraphsView(
        showBackButton: showBackButton,
        previousPageTitle: previousPageTitle,
      ),
    );
  }
}

class CupertinoStyleGraphsView extends StatefulWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleGraphsView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  State<CupertinoStyleGraphsView> createState() => _CupertinoStyleGraphsViewState();
}

class _CupertinoStyleGraphsViewState extends State<CupertinoStyleGraphsView> {
  late ServerModel _server;
  late int? _userId;
  late PlayMetricType _yAxis;
  int _timeRange = 30;
  late GraphsBloc _graphsBloc;
  late UsersBloc _usersBloc;
  late SettingsBloc _settingsBloc;
  final _mediaScrollController = ScrollController();
  final _streamScrollController = ScrollController();
  final _totalsScrollController = ScrollController();
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

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
        return showCupertinoDialog(
          context: context,
          builder: (context) => const CupertinoStyleGraphTipsDialog(),
        );
      });
      _settingsBloc.add(const SettingsUpdateGraphTipsShown(true));
    }
  }

  @override
  void dispose() {
    _mediaScrollController.dispose();
    _streamScrollController.dispose();
    _totalsScrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) {
        if (previous is SettingsSuccess && current is SettingsSuccess) {
          if (previous.appSettings.activeServer != current.appSettings.activeServer) {
            return true;
          }
        }
        return false;
      },
      listener: (context, state) {
        if (state is SettingsSuccess) {
          _server = state.appSettings.activeServer;

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
      child: CupertinoStylePageScaffold(
        showBackButton: widget.showBackButton,
        previousPageTitle: widget.previousPageTitle,
        showServerSelect: true,
        trailing: _navBarActions(),
        middle: const Text(LocaleKeys.graphs_title).tr(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl(
                  groupValue: _selectedIndex,
                  onValueChanged: _onSegmentChanged,
                  children: {
                    0: const Text(LocaleKeys.media_type_title).tr(),
                    1: const Text(LocaleKeys.stream_type_title).tr(),
                    2: const Text(LocaleKeys.play_totals_title).tr(),
                  },
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  CupertinoScrollbar(
                    controller: _mediaScrollController,
                    child: CupertinoStyleRefreshPage(
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
                      scrollController: _mediaScrollController,
                      sliver: const CupertinoStyleMediaTypeGraphsTab(),
                    ),
                  ),
                  CupertinoScrollbar(
                    controller: _streamScrollController,
                    child: CupertinoStyleRefreshPage(
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
                      scrollController: _streamScrollController,
                      sliver: const CupertinoStyleStreamTypeGraphsTab(),
                    ),
                  ),
                  CupertinoScrollbar(
                    controller: _totalsScrollController,
                    child: CupertinoStyleRefreshPage(
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
                      scrollController: _totalsScrollController,
                      sliver: const CupertinoStylePlayTotalsGraphsTab(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSegmentChanged(int? value) {
    if (value == null) return;

    setState(() {
      _selectedIndex = value;
    });

    _pageController.animateToPage(
      value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _navBarActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CupertinoButton(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                CupertinoIcons.calendar,
                color: ThemeHelper.cupertinoNavigationBarItemColor,
              ),
              onPressed: () async {
                final result = await showCupertinoModalPopup(
                  context: context,
                  builder: (_) => CupertinoStyleTimeRangeBottomSheet(
                    initialValue: _timeRange,
                  ),
                );

                if (result != null && result != _timeRange) {
                  setState(() {
                    _timeRange = result;
                  });

                  _settingsBloc.add(
                    SettingsUpdateGraphTimeRange(_timeRange),
                  );

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
              },
            ),
            Positioned(
              bottom: 5,
              right: 6,
              child: IgnorePointer(
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: CupertinoTheme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _timeRange < 100 ? _timeRange.toString() : '99+',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _timeRange < 100 ? 10 : 9,
                        color: CupertinoTheme.of(context).primaryContrastingColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          child: Badge(
            showBadge: _userId != -1,
            badgeAnimation: const BadgeAnimation.fade(toAnimate: false),
            position: BadgePosition.bottomEnd(bottom: -3, end: -3),
            badgeStyle: BadgeStyle(
              badgeColor: CupertinoTheme.of(context).primaryColor,
              borderSide: BorderSide(
                width: 2,
                color: CupertinoTheme.of(context).scaffoldBackgroundColor,
              ),
            ),
            child: const Icon(
              CupertinoIcons.slider_horizontal_3,
              color: ThemeHelper.cupertinoNavigationBarItemColor,
            ),
          ),
          onPressed: () async {
            String? result = await showCupertinoModalPopup(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<UsersBloc>(),
                child: CupertinoStyleGraphsActionsBottomSheet(
                  userId: _userId,
                  yAxis: _yAxis,
                ),
              ),
            );

            if (result == 'user') {
              int? newUserId = await showCupertinoModalPopup(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<UsersBloc>(),
                  child: CupertinoStyleUserFilterBottomSheet(
                    initialValue: _userId!,
                  ),
                ),
              );

              if (newUserId != null && newUserId != _userId) {
                setState(() {
                  _userId = newUserId;

                  _graphsBloc.add(
                    GraphsFetched(
                      server: _server,
                      yAxis: _yAxis,
                      timeRange: _timeRange,
                      userId: _userId,
                      freshFetch: true,
                    ),
                  );
                });
              }
            }
            if (result == 'yAxis') {
              final PlayMetricType? yAxis = await showCupertinoModalPopup(
                context: context,
                builder: (_) => CupertinoStyleYAxisTypeBottomSheet(
                  initialValue: _yAxis,
                ),
              );

              if (yAxis != null && yAxis != _yAxis) {
                setState(() {
                  _yAxis = yAxis;
                });

                _settingsBloc.add(
                  SettingsUpdateGraphYAxis(_yAxis),
                );

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
      ],
    );
  }
}
