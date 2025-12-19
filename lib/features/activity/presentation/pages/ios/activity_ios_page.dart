import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/global_keys/global_keys.dart';
import '../../../../../core/pages/ios/status_ios_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/ios/cupertino_refresh_page.dart';
import '../../../../../core/widgets/ios/cupertino_status_card.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/activity_model.dart';
import '../../../data/models/server_activity_model.dart';
import '../../bloc/activity_bloc.dart';
import '../../widgets/ios/activity_ios_card.dart';
import '../../widgets/ios/activity_ios_server_heading.dart';
import '../../widgets/ios/server_activity_ios_info_card.dart';

class ActivityIosPage extends StatelessWidget {
  const ActivityIosPage({super.key});

  static const routeName = '/activity';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ActivityBloc>(),
      child: const ActivityIosView(),
    );
  }
}

class ActivityIosView extends StatefulWidget {
  const ActivityIosView({super.key});

  @override
  State<ActivityIosView> createState() => _ActivityIosViewState();
}

class _ActivityIosViewState extends State<ActivityIosView> with WidgetsBindingObserver {
  late ActivityBloc _activityBloc;
  late SettingsBloc _settingsBloc;
  late List<ServerModel> _serverList;
  late bool _multiserver;
  late String _activeServerId;
  late Completer<void> _refreshCompleter;
  late DateTime _lastAutoRefresh;

  @override
  void initState() {
    super.initState();
    cupertinoTabController.addListener(
      () {
        if (cupertinoTabController.index == 0) {
          _activityBloc.add(
            ActivityFetched(
              serverList: _serverList,
              multiserver: _multiserver,
              activeServerId: _activeServerId,
              settingsBloc: _settingsBloc,
            ),
          );
        }
      },
    );

    //TODO: Add stuff for rating the app

    _activityBloc = context.read<ActivityBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _serverList = settingsState.serverList;
    _multiserver = settingsState.appSettings.multiserverActivity;
    _activeServerId = settingsState.appSettings.activeServer.tautulliId;

    _refreshCompleter = Completer<void>();
    _lastAutoRefresh = _activityBloc.state.lastAutoRefresh;

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
    return MultiBlocListener(
      listeners: [
        //* Update information set in tab initstate when changed
        BlocListener<SettingsBloc, SettingsState>(
          listenWhen: (previous, current) {
            if (previous is SettingsSuccess && current is SettingsSuccess) {
              if (previous.serverList != current.serverList) {
                return true;
              }
              if (previous.appSettings.multiserverActivity != current.appSettings.multiserverActivity) {
                return true;
              }
              if (previous.appSettings.activeServer != current.appSettings.activeServer) {
                return true;
              }
            }
            return false;
          },
          listener: (context, state) {
            if (state is SettingsSuccess) {
              _serverList = state.serverList;
              _multiserver = state.appSettings.multiserverActivity;
              _activeServerId = state.appSettings.activeServer.tautulliId;
            }
          },
        ),
        //* If active server is changed and multiserver is not set then trigger an ActivityFetched
        BlocListener<SettingsBloc, SettingsState>(
          listenWhen: (previous, current) {
            if (previous is SettingsSuccess && current is SettingsSuccess) {
              if (previous.appSettings.activeServer != current.appSettings.activeServer &&
                  !current.appSettings.multiserverActivity) {
                return true;
              }
            }
            return false;
          },
          listener: (context, state) {
            if (state is SettingsSuccess) {
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
            }
          },
        ),
      ],

      child: BlocSelector<SettingsBloc, SettingsState, bool?>(
        selector: (state) {
          if (state is SettingsSuccess) {
            return state.appSettings.multiserverActivity;
          }
          return null;
        },
        builder: (context, multiserverEnabled) {
          return PageScaffoldCupertino(
            showServerSelect: multiserverEnabled == false,
            middle: const Text(LocaleKeys.activity_title).tr(),
            child: Center(
              child: BlocConsumer<ActivityBloc, ActivityState>(
                listener: (context, state) {
                  if (state.serverActivityList[0].status != BlocStatus.inProgress) {
                    _refreshCompleter.complete();
                    _refreshCompleter = Completer();
                  }

                  if (state.lastAutoRefresh != _lastAutoRefresh) {
                    _lastAutoRefresh = state.lastAutoRefresh;
                  }
                },
                builder: (context, state) {
                  return Builder(
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
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statusWidget({required Widget child}) {
    return CupertinoRefreshPage(
      onRefresh: () {
        _activityBloc.add(
          ActivityFetched(
            serverList: _serverList,
            multiserver: _multiserver,
            activeServerId: _activeServerId,
            settingsBloc: _settingsBloc,
          ),
        );

        return _refreshCompleter.future;
      },
      sliver: SliverFillRemaining(child: child),
    );
  }

  Widget _buildSingleServerActivity({
    required List<ServerActivityModel> serverActivityModelList,
    required bool freshFetch,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    List<Widget> serverActivityWidgets = [];

    if (serverActivityModelList.isEmpty) {
      return _statusWidget(
        child: StatusIosPage(
          message: LocaleKeys.error_message_no_servers.tr(),
          suggestion: LocaleKeys.error_suggestion_register_server.tr(),
        ),
      );
    }

    if (serverActivityModelList.isNotEmpty) {
      final ServerActivityModel firstServer = serverActivityModelList.firstWhere(
        (server) => server.tautulliId == _activeServerId,
      );

      if (firstServer.status == BlocStatus.failure) {
        return _statusWidget(
          child: StatusIosPage(
            message: firstServer.failureMessage ?? '',
            suggestion: firstServer.failureSuggestion ?? '',
          ),
        );
      } else if (freshFetch) {
        return BlocBuilder<ActivityBloc, ActivityState>(
          builder: (context, state) {
            if (state.serverActivityList[0].status == BlocStatus.inProgress) {
              return const CupertinoActivityIndicator();
            }

            return const SizedBox();
          },
        );
      } else if (firstServer.activityList.isEmpty) {
        return _statusWidget(
          child: StatusIosPage(message: LocaleKeys.activity_empty_message.tr()),
        );
      } else {
        for (ActivityModel activityModel in firstServer.activityList) {
          serverActivityWidgets.add(
            ActivityIosCard(
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

        return CupertinoRefreshPage(
          onRefresh: () {
            _activityBloc.add(
              ActivityFetched(
                serverList: _serverList,
                multiserver: _multiserver,
                activeServerId: _activeServerId,
                settingsBloc: _settingsBloc,
              ),
            );

            return _refreshCompleter.future;
          },
          slivers: [
            if (streamCount > 0)
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverToBoxAdapter(
                  child: ServerActivityIosInfoCard(serverActivity: firstServer),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              sliver: SliverGrid.count(
                crossAxisCount: crossAxisCount,
                childAspectRatio:
                    (2 *
                        MediaQuery.of(context).size.width /
                        (360 * 0.85 * MediaQuery.of(context).textScaler.scale(1))) /
                    crossAxisCount,
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
            CupertinoStatusCard(
              isFailure: true,
              message: serverActivityModel.failureMessage ?? '',
              suggestion: serverActivityModel.failureSuggestion,
            ),
          );
        } else if (serverActivityModel.activityList.isEmpty) {
          serverActivityList.add(
            CupertinoStatusCard(
              message: LocaleKeys.activity_empty_message.tr(),
            ),
          );
        } else {
          for (ActivityModel activityModel in serverActivityModel.activityList) {
            serverActivityList.add(
              ActivityIosCard(
                activity: activityModel,
                server: _serverList.firstWhere((server) => server.tautulliId == serverActivityModel.tautulliId),
              ),
            );
          }
        }

        final int streamCount =
            serverActivityModel.copyCount + serverActivityModel.directPlayCount + serverActivityModel.transcodeCount;
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
              header: ActivityIosServerHeading(
                serverName: serverActivityModel.serverName,
                loading: serverActivityModel.status == BlocStatus.inProgress,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    if (streamCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: ServerActivityIosInfoCard(serverActivity: serverActivityModel),
                      ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: crossAxisCount,
                      childAspectRatio:
                          (2 *
                              MediaQuery.of(context).size.width /
                              (360 * 0.85 * MediaQuery.of(context).textScaler.scale(1))) /
                          crossAxisCount,
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

      return CupertinoRefreshPage(
        onRefresh: () {
          _activityBloc.add(
            ActivityFetched(
              serverList: _serverList,
              multiserver: _multiserver,
              activeServerId: _activeServerId,
              settingsBloc: _settingsBloc,
            ),
          );

          return _refreshCompleter.future;
        },
        slivers: activityServerList,
      );
    }

    return const SizedBox();
  }
}
