// @dart=2.9

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:quiver/strings.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/inherited_headers.dart';
import '../../../../core/widgets/inner_drawer_scaffold.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../terminate_session/presentation/bloc/terminate_session_bloc.dart';
import '../../domain/entities/activity.dart';
import '../bloc/activity_bloc.dart';
import '../bloc/geo_ip_bloc.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_error_button.dart';
import '../widgets/bandwidth_header.dart';

// Due to multiple builds of the ActivityPage on app start this
// ensures no repeat pushes of the ChangelogPage
bool changelogTriggered = false;

class ActivityPage extends StatelessWidget {
  final bool showChangelog;

  const ActivityPage({
    Key key,
    this.showChangelog = false,
  }) : super(key: key);

  static const routeName = '/activity';

  @override
  Widget build(BuildContext context) {
    // Display changelog page
    if (showChangelog && !changelogTriggered) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed('/changelog');
      });
      changelogTriggered = true;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<ActivityBloc>(
          create: (_) => sl<ActivityBloc>()
            ..add(
              ActivityLoadAndRefresh(
                settingsBloc: context.read<SettingsBloc>(),
              ),
            ),
        ),
        BlocProvider<GeoIpBloc>(
          create: (_) => sl<GeoIpBloc>(),
        ),
      ],
      child: const ActivityPageContent(),
    );
  }
}

class ActivityPageContent extends StatefulWidget {
  const ActivityPageContent({Key key}) : super(key: key);

  @override
  _ActivityPageContentState createState() => _ActivityPageContentState();
}

class _ActivityPageContentState extends State<ActivityPageContent>
    with WidgetsBindingObserver {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // Take action if the app is paused or resumed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      context.read<ActivityBloc>().add(ActivityAutoRefreshStop());
    }
    if (state == AppLifecycleState.resumed) {
      context.read<ActivityBloc>().add(
            ActivityLoadAndRefresh(
              settingsBloc: context.read<SettingsBloc>(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InnerDrawerScaffold(
      title: Text(
        LocaleKeys.activity_page_title.tr(),
      ),
      body: BlocConsumer<ActivityBloc, ActivityState>(
        listener: (context, state) {
          if (state is ActivityLoaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is ActivityLoaded) {
            return BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                if (settingsState is SettingsLoadSuccess) {
                  final bool multiserver = settingsState.serverList.length > 1;
                  //* If single server display different widgets for failure
                  //* and inProgress then multiserver would display
                  if (!multiserver) {
                    final Map<String, dynamic> serverMap =
                        state.activityMap.values.toList()[0];
                    final ActivityLoadingState result =
                        serverMap['loadingState'];
                    if (result == ActivityLoadingState.failure) {
                      final Failure failure = serverMap['failure'];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ErrorMessage(
                            failure: failure,
                            message: FailureMapperHelper.mapFailureToMessage(
                                failure),
                            suggestion:
                                FailureMapperHelper.mapFailureToSuggestion(
                                    failure),
                          ),
                          ActivityErrorButton(
                            completer: _refreshCompleter,
                            failure: failure,
                          ),
                        ],
                      );
                    } else if (result == ActivityLoadingState.inProgress &&
                        serverMap['activityList'].isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).accentColor,
                        ),
                      );
                    }
                  }

                  return RefreshIndicator(
                    color: Theme.of(context).accentColor,
                    onRefresh: () {
                      context.read<ActivityBloc>().add(
                            ActivityLoadAndRefresh(
                              settingsBloc: context.read<SettingsBloc>(),
                            ),
                          );
                      return _refreshCompleter.future;
                    },
                    child: multiserver
                        ? _buildMultiserverActivity(
                            activityMap: state.activityMap,
                            serverList: settingsState.serverList,
                          )
                        : _buildSingleServerActivity(
                            activityMap: state.activityMap,
                            timeFormat: settingsState.serverList[0].timeFormat,
                            headerList:
                                settingsState.serverList[0].customHeaders,
                          ),
                  );
                } else {
                  return const Text(LocaleKeys.settings_not_loaded_error).tr();
                }
              },
            );
          }
          if (state is ActivityLoadFailure) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ErrorMessage(
                  failure: state.failure,
                  message: state.message,
                  suggestion: state.suggestion,
                ),
                ActivityErrorButton(
                  completer: _refreshCompleter,
                  failure: state.failure,
                ),
              ],
            );
          }
          return const SizedBox(height: 0, width: 0);
        },
      ),
    );
  }
}

Widget _buildSingleServerActivity({
  @required Map<String, Map<String, Object>> activityMap,
  @required String timeFormat,
  List<CustomHeaderModel> headerList = const [],
}) {
  Map<String, Map<String, Object>> map = activityMap;
  List mapKeys = map.keys.toList();
  List<ActivityItem> activityList = map[mapKeys[0]]['activityList'];
  Map bandwidthMap = map[mapKeys[0]]['bandwidth'];
  Map<String, String> headerMap = {};

  for (CustomHeaderModel header in headerList) {
    headerMap[header.key] = header.value;
  }

  if (activityList.isEmpty) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: constraints.maxHeight,
          child: Center(
            child: Text(
              '${LocaleKeys.activity_empty.tr()}.',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  final SlidableController _slidableController = SlidableController();
  List<Widget> serverActivityList = [];

  for (ActivityItem activityItem in activityList) {
    serverActivityList.add(
      InheritedHeaders(
        headerMap: headerMap,
        child: ActivityCard(
          activityMap: activityMap,
          index: activityList.indexOf(activityItem),
          tautulliId: mapKeys[0],
          timeFormat: timeFormat,
          slidableController: _slidableController,
        ),
      ),
    );
  }

  return BlocProvider<TerminateSessionBloc>(
    create: (context) => di.sl<TerminateSessionBloc>(),
    child: CustomScrollView(
      slivers: [
        SliverStickyHeader(
          header: DecoratedBox(
            decoration: const BoxDecoration(
              color: TautulliColorPalette.midnight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: BandwidthHeader(bandwidthMap: bandwidthMap),
            ),
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return serverActivityList[index];
              },
              childCount: serverActivityList.length,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildMultiserverActivity({
  @required Map<String, Map<String, Object>> activityMap,
  @required List<ServerModel> serverList,
}) {
  List<Widget> activityWidgetList = [];
  String tautulliId;

  final SlidableController _slidableController = SlidableController();

  activityMap.forEach((serverId, serverData) {
    tautulliId = serverId;
    List activityList = serverData['activityList'];
    List<Widget> serverActivityList = [];
    Map<String, String> headerMap = {};

    List<CustomHeaderModel> headerList = serverList
        .firstWhere((server) => server.tautulliId == tautulliId)
        .customHeaders;
    for (CustomHeaderModel header in headerList) {
      headerMap[header.key] = header.value;
    }

    if (serverData['loadingState'] == ActivityLoadingState.inProgress) {
      if (serverData['failure'] == null) {
        if (activityList.isEmpty) {
          serverActivityList.add(
            const _StatusCard(
                customMessage: 'Nothing is currently being played.'),
          );
        } else {
          for (ActivityItem activityItem in activityList) {
            serverActivityList.add(
              InheritedHeaders(
                headerMap: headerMap,
                child: ActivityCard(
                  activityMap: activityMap,
                  index: activityList.indexOf(activityItem),
                  tautulliId: tautulliId,
                  timeFormat: serverList
                      .firstWhere((server) => server.tautulliId == tautulliId)
                      .timeFormat,
                  slidableController: _slidableController,
                ),
              ),
            );
          }
        }
      } else {
        serverActivityList.add(
          LayoutBuilder(
            builder: (context, constraints) {
              return _StatusCard(failure: serverData['failure']);
            },
          ),
        );
      }
    }
    if (serverData['loadingState'] == ActivityLoadingState.success) {
      if (activityList.isNotEmpty) {
        for (ActivityItem activityItem in activityList) {
          serverActivityList.add(
            InheritedHeaders(
              headerMap: headerMap,
              child: ActivityCard(
                activityMap: activityMap,
                index: activityList.indexOf(activityItem),
                tautulliId: tautulliId,
                timeFormat: serverList
                    .firstWhere((server) => server.tautulliId == tautulliId)
                    .timeFormat,
                slidableController: _slidableController,
              ),
            ),
          );
        }
      } else {
        serverActivityList.add(
          _StatusCard(
            customMessage: '${LocaleKeys.activity_empty.tr()}.',
          ),
        );
      }
    }
    if (serverData['loadingState'] == ActivityLoadingState.failure) {
      serverActivityList.add(
        LayoutBuilder(
          builder: (context, constraints) {
            return _StatusCard(failure: serverData['failure']);
          },
        ),
      );
    }

    activityWidgetList.add(
      SliverStickyHeader(
        header: ServerHeader(
          color: TautulliColorPalette.midnight,
          serverName: serverData['plex_name'],
          state: serverData['loadingState'],
          secondWidget: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: BandwidthHeader(bandwidthMap: serverData['bandwidth']),
          ),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return serverActivityList[index];
            },
            childCount: serverActivityList.length,
          ),
        ),
      ),
    );
  });

  return BlocProvider<TerminateSessionBloc>(
    create: (context) => di.sl<TerminateSessionBloc>(),
    child: Padding(
      padding: const EdgeInsets.only(top: 4),
      child: CustomScrollView(
        slivers: activityWidgetList,
      ),
    ),
  );
}

class _StatusCard extends StatelessWidget {
  final String customMessage;
  final Failure failure;

  const _StatusCard({
    Key key,
    this.customMessage,
    this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String failureMessage;
    String failureSuggestion;

    if (failure != null) {
      failureMessage = FailureMapperHelper.mapFailureToMessage(failure);
      failureSuggestion = FailureMapperHelper.mapFailureToSuggestion(failure);
    }

    return Container(
      margin: const EdgeInsets.all(4),
      height: 135,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: TautulliColorPalette.gunmetal,
        margin: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (customMessage != null)
              Center(
                child: Text(
                  customMessage,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            if (customMessage == null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                ),
                child: Text(
                  isNotEmpty(failureMessage)
                      ? failureMessage
                      : LocaleKeys.general_unknown_error.tr(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            if (isNotEmpty(failureSuggestion))
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                ),
                child: Text(
                  failureSuggestion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
