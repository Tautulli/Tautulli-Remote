import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/rate_app/rate_app.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../core/widgets/status_card.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/server_activity_model.dart';
import '../bloc/activity_bloc.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_server_heading.dart';
import '../widgets/server_activity_info_card.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  static const routeName = '/activity';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ActivityBloc>(),
      child: const ActivityView(),
    );
  }
}

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> with WidgetsBindingObserver {
  late ActivityBloc _activityBloc;
  late SettingsBloc _settingsBloc;
  late List<ServerModel> _serverList;
  late bool _multiserver;
  late String _activeServerId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (rateApp.shouldOpenDialog) {
        rateApp.showRateDialog(
          context,
          ignoreNativeDialog: true,
          title: LocaleKeys.rate_app_title.tr(),
          message: LocaleKeys.rate_app_message.tr(),
          actionsBuilder: (context) => [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () async {
                await rateApp.callEvent(RateMyAppEventType.noButtonPressed);
                Navigator.of(context).pop<RateMyAppDialogButton>(
                  RateMyAppDialogButton.no,
                );
              },
              child: const Text(LocaleKeys.dont_ask_again_message).tr(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () async {
                await rateApp.callEvent(RateMyAppEventType.laterButtonPressed);
                Navigator.of(context).pop<RateMyAppDialogButton>(
                  RateMyAppDialogButton.later,
                );
              },
              child: const Text(LocaleKeys.later_title).tr(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () async {
                await rateApp.launchStore();
                await rateApp.callEvent(RateMyAppEventType.rateButtonPressed);
                Navigator.of(context).pop<RateMyAppDialogButton>(
                  RateMyAppDialogButton.rate,
                );
              },
              child: const Text(LocaleKeys.review_title).tr(),
            ),
          ],
        );
      }
    });

    _activityBloc = context.read<ActivityBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _serverList = settingsState.serverList;
    _multiserver = settingsState.appSettings.multiserverActivity;
    _activeServerId = settingsState.appSettings.activeServer.tautulliId;

    _activityBloc.add(
      ActivityFetched(
        serverList: _serverList,
        multiserver: _multiserver,
        activeServerId: _activeServerId,
        settingsBloc: _settingsBloc,
      ),
    );

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // Take action if the app is paused or resumed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      context.read<ActivityBloc>().add(ActivityAutoRefreshStop());
    }
    if (state == AppLifecycleState.resumed) {
      _activityBloc.add(
        ActivityFetched(
          serverList: _serverList,
          multiserver: _multiserver,
          activeServerId: _activeServerId,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) {
        // If active server is changed and multiserver is not set then trigger an ActivityFetched
        if (previous is SettingsSuccess && current is SettingsSuccess) {
          if (previous.appSettings.activeServer != current.appSettings.activeServer && !current.appSettings.multiserverActivity) {
            return true;
          }
        }
        return false;
      },
      listener: (context, state) {
        state as SettingsSuccess;

        _activeServerId = state.appSettings.activeServer.tautulliId;

        _activityBloc.add(
          ActivityFetched(
            serverList: _serverList,
            multiserver: _multiserver,
            activeServerId: _activeServerId,
            freshFetch: true,
            settingsBloc: _settingsBloc,
          ),
        );
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.activity_title).tr(),
        body: BlocBuilder<ActivityBloc, ActivityState>(
          builder: (context, state) {
            return ThemedRefreshIndicator(
              onRefresh: () {
                _activityBloc.add(
                  ActivityFetched(
                    serverList: _serverList,
                    multiserver: _multiserver,
                    activeServerId: _activeServerId,
                    settingsBloc: _settingsBloc,
                  ),
                );

                return Future.value();
              },
              child: PageBody(
                loading: !_multiserver &&
                        state.serverActivityList.isNotEmpty &&
                        state.serverActivityList.firstWhere((s) => s.tautulliId == _activeServerId).status == BlocStatus.inProgress
                    ? true
                    : false,
                child: Builder(
                  builder: (context) {
                    if (_multiserver && _serverList.length > 1) {
                      return _buildMultiserverActivity(
                        serverActivityModelList: state.serverActivityList,
                      );
                    } else {
                      return _buildSingleServerActivity(
                        serverActivityModelList: state.serverActivityList,
                        freshFetch: state.freshFetch,
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSingleServerActivity({
    required List<ServerActivityModel> serverActivityModelList,
    required bool freshFetch,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    List<Widget> serverActivityWidgets = [];

    if (serverActivityModelList.isEmpty) {
      return StatusPage(
        scrollable: true,
        message: LocaleKeys.error_message_no_servers.tr(),
        suggestion: LocaleKeys.error_suggestion_register_server.tr(),
      );
    }

    if (serverActivityModelList.isNotEmpty) {
      final ServerActivityModel firstServer = serverActivityModelList.firstWhere(
        (server) => server.tautulliId == _activeServerId,
      );

      if (firstServer.status == BlocStatus.failure) {
        return StatusPage(
          scrollable: true,
          message: firstServer.failureMessage ?? '',
          suggestion: firstServer.failureSuggestion ?? '',
        );
      } else if (freshFetch) {
        return const SizedBox();
      } else if (firstServer.activityList.isEmpty) {
        return StatusPage(
          scrollable: true,
          message: LocaleKeys.activity_empty_message.tr(),
        );
      } else {
        for (ActivityModel activityModel in firstServer.activityList) {
          serverActivityWidgets.add(
            ActivityCard(
              activity: activityModel,
              server: _serverList.firstWhere((server) => server.tautulliId == firstServer.tautulliId),
            ),
          );
        }

        final int streamCount = firstServer.copyCount + firstServer.directPlayCount + firstServer.transcodeCount;
        late int crossAxisCount;

        if (screenWidth > 1000) {
          crossAxisCount = 3;
        } else if (screenWidth > 580) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return CustomScrollView(
          slivers: [
            if (streamCount > 0)
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverToBoxAdapter(
                  child: ServerActivityInfoCard(serverActivity: firstServer),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              sliver: SliverGrid.count(
                crossAxisCount: crossAxisCount,
                childAspectRatio: (2 * MediaQuery.of(context).size.width / (360 * 0.85 * MediaQuery.of(context).textScaler.scale(1))) / crossAxisCount,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: serverActivityWidgets,
              ),
            ),
          ],
        );
      }
    }

    return const SizedBox();
  }

  Widget _buildMultiserverActivity({
    required List<ServerActivityModel> serverActivityModelList,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    List<Widget> activityServerList = [];

    if (serverActivityModelList.isNotEmpty) {
      for (ServerActivityModel serverActivityModel in serverActivityModelList) {
        List<Widget> serverActivityList = [];
        if (serverActivityModel.status == BlocStatus.failure) {
          serverActivityList.add(
            StatusCard(
              isFailure: true,
              message: serverActivityModel.failureMessage ?? '',
              suggestion: serverActivityModel.failureSuggestion,
            ),
          );
        } else if (serverActivityModel.activityList.isEmpty) {
          serverActivityList.add(
            StatusCard(
              message: LocaleKeys.activity_empty_message.tr(),
            ),
          );
        } else {
          for (ActivityModel activityModel in serverActivityModel.activityList) {
            serverActivityList.add(
              ActivityCard(
                activity: activityModel,
                server: _serverList.firstWhere((server) => server.tautulliId == serverActivityModel.tautulliId),
              ),
            );
          }
        }

        final int streamCount = serverActivityModel.copyCount + serverActivityModel.directPlayCount + serverActivityModel.transcodeCount;
        late int crossAxisCount;

        if (screenWidth > 1000) {
          crossAxisCount = 3;
        } else if (screenWidth > 580) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        activityServerList.add(
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            sliver: SliverStickyHeader(
              header: ActivityServerHeading(
                serverName: serverActivityModel.serverName,
                loading: serverActivityModel.status == BlocStatus.inProgress,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    if (streamCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: ServerActivityInfoCard(serverActivity: serverActivityModel),
                      ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: (2 * MediaQuery.of(context).size.width / (360 * 0.85 * MediaQuery.of(context).textScaler.scale(1))) / crossAxisCount,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: serverActivityList,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return CustomScrollView(
        slivers: activityServerList,
      );
    }

    return const SizedBox();
  }
}
