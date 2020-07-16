import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../injection_container.dart' as di;
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/onesignal_connection_banner.dart';
import '../widgets/server_info.dart';
import '../widgets/settings_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final oneSignalPrivacyBloc = BlocProvider.of<OneSignalPrivacyBloc>(context);
    final oneSignalHealthBloc = BlocProvider.of<OneSignalHealthBloc>(context);

    if (oneSignalPrivacyBloc.state is OneSignalPrivacyConsentSuccess) {
      oneSignalHealthBloc.add(OneSignalHealthCheck());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: AppDrawer(),
      body: BlocProvider(
        create: (context) => di.sl<RegisterDeviceBloc>(),
        child: BlocListener<RegisterDeviceBloc, RegisterDeviceState>(
          listener: (context, state) {
            if (state is RegisterDeviceFailure) {
              Scaffold.of(context).hideCurrentSnackBar();
              //TODO: add a link to a wiki page for registration
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Tautulli Registration Failed'),
                ),
              );
            }
            if (state is RegisterDeviceSuccess) {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Tautulli Registration Successful'),
                ),
              );
            }
          },
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoadSuccess) {
                return ListView(
                  children: <Widget>[
                    //* OneSignal connection banner
                    BlocBuilder<OneSignalHealthBloc, OneSignalHealthState>(
                      builder: (context, state) {
                        // make sure the user has consented to OneSignal privacy before displaying banner
                        if (state is OneSignalHealthFailure &&
                            oneSignalPrivacyBloc.state
                                is OneSignalPrivacyConsentSuccess) {
                          return OneSignalConnectionBanner();
                        }
                        return Container(width: 0, height: 0);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SettingsHeader(
                      headingText: 'Server Info',
                    ),
                    ServerInfo(
                      settings: state.settings,
                    ),
                    ListTile(
                      title: Text(
                        'Advanced server settings',
                        style: TextStyle(fontSize: 16),
                      ),
                      dense: true,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/advanced_server_settings');
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     left: 10,
                    //     right: 10,
                    //     bottom: 10,
                    //   ),
                    //   child: Divider(
                    //     color: Theme.of(context).accentColor,
                    //   ),
                    // ),
                    // SettingsHeader(
                    //   headingText: 'App Settings',
                    // ),
                  ],
                );
              } else {
                //TODO: Handle if the settings state is something other than Loaded
                return Text('Something went wrong loading settings');
              }
            },
          ),
        ),
      ),
    );
  }
}
