import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/helpers/failure_message_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../injection_container.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../terminate_session/presentation/bloc/terminate_session_bloc.dart';
import '../../domain/entities/activity.dart';
import '../bloc/activity_bloc.dart';
import '../widgets/activity_card.dart';
import '../widgets/error_button.dart';
import '../widgets/error_message.dart';
import '../widgets/server_header.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key key}) : super(key: key);

  static const routeName = '/activity';

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Activity'),
      ),
      drawer: AppDrawer(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ActivityBloc>(
            create: (_) => sl<ActivityBloc>()..add(ActivityLoad()),
          ),
        ],
        child: BlocConsumer<ActivityBloc, ActivityState>(
          listener: (context, state) {
            if (state is ActivityLoadSuccess) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, state) {
            if (state is ActivityLoadFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ErrorMessage(
                    failure: state.failure,
                    message: state.message,
                    suggestion: state.suggestion,
                  ),
                  ErrorButton(
                    completer: _refreshCompleter,
                    failure: state.failure,
                  ),
                ],
              );
            }
            if (state is ActivityEmpty) {
              return Text('Empty State');
            }
            if (state is ActivityLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ActivityLoadSuccess) {
              if (state.activityMap.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () {
                    BlocProvider.of<ActivityBloc>(context)
                        .add(ActivityRefresh());
                    return _refreshCompleter.future;
                  },
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) =>
                            SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: constraints.maxHeight,
                        child: Center(
                          child: Text(
                            'Nothing is currently being played.',
                            style: TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, settingsState) {
                    if (settingsState is SettingsLoadSuccess) {
                      final bool multiserver =
                          settingsState.serverList.length > 1;

                      return RefreshIndicator(
                        onRefresh: () {
                          BlocProvider.of<ActivityBloc>(context)
                              .add(ActivityRefresh());
                          return _refreshCompleter.future;
                        },
                        child: multiserver
                            ? _buildMultiserverActivity(
                                activityMap: state.activityMap,
                              )
                            : _buildSingleServerActivity(
                                activityMap: state.activityMap,
                              ),
                        // ListView(
                        //   children: activityWidgetList,
                        // ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}

Widget _buildSingleServerActivity({
  @required Map<String, Map<String, Object>> activityMap,
}) {
  Map<String, Map<String, Object>> map = activityMap;
  List mapKeys = map.keys.toList();
  List<ActivityItem> activityList = map[mapKeys[0]]['activity'];

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
              style: TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.w600,
              ),
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

  activityMap.forEach((serverId, resultMap) {
    tautulliId = serverId;
    activityWidgetList.add(
      ServerHeader(
        serverName: resultMap['plex_name'],
        alert: resultMap['result'] == 'failure',
      ),
    );
    if (resultMap['result'] == 'success') {
      final List<ActivityItem> activityList = resultMap['activity'];

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
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              top: 4,
              bottom: 8,
            ),
            child: Text(
              'Nothing is currently being played.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        );
      }
    }
    if (resultMap['result'] == 'failure') {
      activityWidgetList.add(
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 4,
                            ),
                            child: Text(
                              FailureMessageHelper()
                                  .mapFailureToMessage(resultMap['failure']),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 4,
                            ),
                            child: Text(
                              FailureMessageHelper()
                                  .mapFailureToSuggestion(resultMap['failure']),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  });

  return BlocProvider<TerminateSessionBloc>(
    create: (context) => di.sl<TerminateSessionBloc>(),
    child: ListView(
      children: activityWidgetList,
    ),
  );
}
