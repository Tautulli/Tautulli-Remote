import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../injection_container.dart' as di;
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/server_info.dart';
import '../widgets/settings_alert.dart';
import '../widgets/settings_header.dart';
import '../widgets/custom_settings_tile.dart';

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SettingsAlert(),
                    ),
                    SettingsHeader(
                      headingText: 'Server Info',
                    ),
                    ServerInfo(
                      settings: state.settings,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SettingsHeader(
                        headingText: 'Server Settings',
                      ),
                    ),
                    CustomSettingsTile(
                      title: 'Register with Tautulli',
                      icon: FaIcon(
                        FontAwesomeIcons.qrcode,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        final qrCodeScan =
                            await FlutterBarcodeScanner.scanBarcode(
                          '#e5a00d',
                          'Cancel',
                          false,
                          ScanMode.QR,
                        );
                        // Passes in the SettingsBloc to maintain context so items update correctly
                        BlocProvider.of<RegisterDeviceBloc>(context).add(
                          RegisterDeviceFromQrStarted(
                            result: qrCodeScan,
                            settingsBloc:
                                BlocProvider.of<SettingsBloc>(context),
                          ),
                        );
                      },
                    ),
                    // ListTile(
                    //   title: Text('Register with Tautulli'),
                    //   onTap: () async {
                    //     final qrCodeScan =
                    //         await FlutterBarcodeScanner.scanBarcode(
                    //       '#e5a00d',
                    //       'Cancel',
                    //       false,
                    //       ScanMode.QR,
                    //     );
                    //     // Passes in the SettingsBloc to maintain context so items update correctly
                    //     BlocProvider.of<RegisterDeviceBloc>(context).add(
                    //       RegisterDeviceFromQrStarted(
                    //         result: qrCodeScan,
                    //         settingsBloc:
                    //             BlocProvider.of<SettingsBloc>(context),
                    //       ),
                    //     );
                    //   },
                    // ),
                    CustomSettingsTile(
                      title: 'Advanced server settings',
                      icon: FaIcon(
                        FontAwesomeIcons.cogs,
                        color: Colors.white,
                      ),
                      onTap: () => Navigator.of(context)
                          .pushNamed('/advanced_server_settings'),
                    ),
                    // ListTile(
                    //   title: Text(
                    //     'Advanced server settings',
                    //     style: TextStyle(fontSize: 16),
                    //   ),
                    //   dense: true,
                    //   onTap: () {
                    //     Navigator.of(context)
                    //         .pushNamed('/advanced_server_settings');
                    //   },
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      child: Divider(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    CustomSettingsTile(
                      title: 'Tautulli Remote Logs',
                      icon: FaIcon(
                        FontAwesomeIcons.solidListAlt,
                        color: Colors.white,
                      ),
                      onTap: () => Navigator.of(context).pushNamed('/logs'),
                    ),
                    // ListTile(
                    //   leading: FaIcon(
                    //     FontAwesomeIcons.solidListAlt,
                    //     color: Colors.white,
                    //   ),
                    //   title: Text('Tautulli Remote Logs'),
                    //   onTap: () => Navigator.of(context).pushNamed('/logs'),
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
