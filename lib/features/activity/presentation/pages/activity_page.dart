import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../injection_container.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
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
                                geoIpMap: state.geoIpMap,
                                serverList: settingsState.serverList,
                                tautulliApiUrls: state.tautulliApiUrls,
                              )
                            : _buildSingleServerActivity(
                                activityMap: state.activityMap,
                                geoIpMap: state.geoIpMap,
                                serverList: settingsState.serverList,
                                tautulliApiUrls: state.tautulliApiUrls,
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
  @required Map<String, dynamic> geoIpMap,
  @required List<ServerModel> serverList,
  @required TautulliApiUrls tautulliApiUrls,
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
  return ListView.builder(
    itemCount: activityList.length,
    itemBuilder: (context, index) => ActivityCard(
      activity: activityList[index],
      geoIp: geoIpMap[activityList[index].ipAddress],
      server: serverList[0],
      tautulliApiUrls: tautulliApiUrls,
    ),
  );
}

Widget _buildMultiserverActivity({
  @required Map<String, Map<String, Object>> activityMap,
  @required Map<String, dynamic> geoIpMap,
  @required List<ServerModel> serverList,
  @required TautulliApiUrls tautulliApiUrls,
}) {
  List<Widget> activityWidgetList = [];

  activityMap.forEach((tautulliId, resultMap) {
    activityWidgetList.add(
      ServerHeader(serverName: resultMap['plex_name']),
    );
    if (resultMap['result'] == 'success') {
      final List<ActivityItem> activityList = resultMap['activity'];

      if (activityList.isNotEmpty) {
        for (ActivityItem activityItem in activityList) {
          activityWidgetList.add(
            ActivityCard(
              activity: activityItem,
              geoIp: geoIpMap[activityItem.ipAddress],
              server: serverList.firstWhere((e) => e.tautulliId == tautulliId),
              tautulliApiUrls: tautulliApiUrls,
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
              style: TextStyle(color: Colors.grey),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                ),
                child: Text(
                  _mapFailureToMessage(resultMap['failure']),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                ),
                child: Text(
                  _mapFailureToSuggestion(resultMap['failure']),
                ),
              ),
            ],
          ),
        ),
      );
    }
  });

  return ListView(
    children: activityWidgetList,
  );
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case ConnectionFailure:
      return CONNECTION_FAILURE_MESSAGE;
    case SettingsFailure:
      return SETTINGS_FAILURE_MESSAGE;
    case SocketFailure:
      return SOCKET_FAILURE_MESSAGE;
    case TlsFailure:
      return TLS_FAILURE_MESSAGE;
    case UrlFormatFailure:
      return URL_FORMAT_FAILURE_MESSAGE;
    case TimeoutFailure:
      return TIMEOUT_FAILURE_MESSAGE;
    default:
      return 'Unexpected error';
  }
}

String _mapFailureToSuggestion(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return CHECK_SERVER_SETTINGS_SUGGESTION;
    case SettingsFailure:
      return CHECK_SERVER_SETTINGS_SUGGESTION;
    case SocketFailure:
      return CHECK_CONNECTION_ADDRESS_SUGGESTION;
    case TlsFailure:
      return CHECK_CONNECTION_ADDRESS_SUGGESTION;
    case UrlFormatFailure:
      return CHECK_CONNECTION_ADDRESS_SUGGESTION;
    case TimeoutFailure:
      return CHECK_CONNECTION_ADDRESS_SUGGESTION;
    default:
      return '';
  }
}


