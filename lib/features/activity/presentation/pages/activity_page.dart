import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../injection_container.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/activity_bloc.dart';
import '../widgets/activity_card.dart';
import '../widgets/error_message.dart';
import '../widgets/error_button.dart';

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
                  // RaisedButton.icon(
                  //   icon: FaIcon(FontAwesomeIcons.redoAlt),
                  //   label: Text('Retry'),
                  //   color: Theme.of(context).primaryColor,
                  //   onPressed: () {
                  //     BlocProvider.of<ActivityBloc>(context)
                  //         .add(ActivityLoad());
                  //     return _refreshCompleter.future;
                  //   },
                  // ),
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
              if (state.activity.isEmpty) {
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
                      return RefreshIndicator(
                        onRefresh: () {
                          BlocProvider.of<ActivityBloc>(context)
                              .add(ActivityRefresh());
                          return _refreshCompleter.future;
                        },
                        child: ListView.builder(
                          itemCount: state.activity.length,
                          itemBuilder: (context, index) => ActivityCard(
                            activity: state.activity[index],
                            geoIp:
                                state.geoIpMap[state.activity[index].ipAddress],
                            settings: settingsState.settings,
                            tautulliApiUrls: state.tautulliApiUrls,
                          ),
                        ),
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
