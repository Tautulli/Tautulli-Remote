import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/server_header.dart';
import '../../../../injection_container.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../terminate_session/presentation/bloc/terminate_session_bloc.dart';
import '../../domain/entities/activity.dart';
import '../bloc/activity_bloc.dart';
import '../bloc/geo_ip_bloc.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_error_button.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key key}) : super(key: key);

  static const routeName = '/activity';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ActivityBloc>(
          create: (_) => sl<ActivityBloc>()..add(ActivityLoadAndRefresh()),
        ),
        BlocProvider<GeoIpBloc>(
          create: (_) => sl<GeoIpBloc>(),
        ),
      ],
      child: ActivityPageContent(),
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
      context.bloc<ActivityBloc>().add(ActivityAutoRefreshStop());
      Navigator.popUntil(context, (route) => !(route is PopupRoute));
    }
    if (state == AppLifecycleState.resumed) {
      context.bloc<ActivityBloc>().add(ActivityLoadAndRefresh());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Activity'),
      ),
      drawer: AppDrawer(),
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
                  //* If single server display differnet widgets for failure and inProgress then multiserver would
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
                        child: CircularProgressIndicator(),
                      );
                    }
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      BlocProvider.of<ActivityBloc>(context)
                          .add(ActivityLoadAndRefresh());
                      return _refreshCompleter.future;
                    },
                    child: multiserver
                        ? _buildMultiserverActivity(
                            activityMap: state.activityMap,
                          )
                        : _buildSingleServerActivity(
                            activityMap: state.activityMap,
                          ),
                  );
                } else {
                  return Text('ERROR: Settings not loaded');
                }
              },
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
}) {
  Map<String, Map<String, Object>> map = activityMap;
  List mapKeys = map.keys.toList();
  List<ActivityItem> activityList = map[mapKeys[0]]['activityList'];

  if (activityList.isEmpty) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: constraints.maxHeight,
          child: Center(
            child: Text(
              'Nothing is currently being played.',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  final SlidableController _slidableController = SlidableController();
  return BlocProvider<TerminateSessionBloc>(
    create: (context) => di.sl<TerminateSessionBloc>(),
    child: ListView.builder(
      itemCount: activityList.length,
      itemBuilder: (context, index) => ActivityCard(
        activityMap: activityMap,
        index: index,
        tautulliId: mapKeys[0],
        slidableController: _slidableController,
      ),
    ),
  );
}

Widget _buildMultiserverActivity({
  @required Map<String, Map<String, Object>> activityMap,
}) {
  List<Widget> activityWidgetList = [];
  String tautulliId;

  final SlidableController _slidableController = SlidableController();

  activityMap.forEach((serverId, serverData) {
    tautulliId = serverId;
    List activityList = serverData['activityList'];

    activityWidgetList.add(
      ServerHeader(
        serverName: serverData['plex_name'],
        state: serverData['loadingState'],
      ),
    );
    if (serverData['loadingState'] == ActivityLoadingState.inProgress) {
      if (serverData['failure'] == null) {
        if (activityList.isEmpty) {
          activityWidgetList.add(
            _StatusCard(customMessage: 'Nothing is currently being played.'),
          );
        } else {
          for (ActivityItem activityItem in activityList) {
            activityWidgetList.add(
              ActivityCard(
                activityMap: activityMap,
                index: activityList.indexOf(activityItem),
                tautulliId: tautulliId,
                slidableController: _slidableController,
              ),
            );
          }
        }
      } else {
        activityWidgetList.add(
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
          activityWidgetList.add(
            ActivityCard(
              activityMap: activityMap,
              index: activityList.indexOf(activityItem),
              tautulliId: tautulliId,
              slidableController: _slidableController,
            ),
          );
        }
      } else {
        activityWidgetList.add(
          _StatusCard(customMessage: 'Nothing is currently being played.'),
        );
      }
    }
    if (serverData['loadingState'] == ActivityLoadingState.failure) {
      activityWidgetList.add(
        LayoutBuilder(
          builder: (context, constraints) {
            return _StatusCard(failure: serverData['failure']);
          },
        ),
      );
    }
  });

  return BlocProvider<TerminateSessionBloc>(
    create: (context) => di.sl<TerminateSessionBloc>(),
    child: Padding(
      padding: const EdgeInsets.only(top: 4),
      child: ListView(
        children: activityWidgetList,
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
    return Container(
      margin: const EdgeInsets.all(4),
      height: 135,
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
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            if (failure != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                ),
                child: Text(
                  FailureMapperHelper.mapFailureToMessage(failure),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            if (failure != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                ),
                child: Text(
                  FailureMapperHelper.mapFailureToSuggestion(failure),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
