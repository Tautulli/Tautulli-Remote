import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';
import 'package:unicorndial/unicorndial.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../injection_container.dart' as di;
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/custom_settings_tile.dart';
import '../widgets/server_setup_instructions.dart';
import '../widgets/settings_alert_banner.dart';
import '../widgets/settings_header.dart';
import 'server_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    // Makes sure RegisterDeviceBloc is available for the FAB
    return BlocProvider(
      create: (context) => di.sl<RegisterDeviceBloc>(),
      child: SettingsPageContent(),
    );
  }
}

class SettingsPageContent extends StatelessWidget {
  const SettingsPageContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final oneSignalPrivacyBloc = BlocProvider.of<OneSignalPrivacyBloc>(context);
    final oneSignalHealthBloc = BlocProvider.of<OneSignalHealthBloc>(context);
    TextEditingController _primaryConnectionAddressController =
        TextEditingController();
    TextEditingController _deviceTokenController = TextEditingController();

    if (oneSignalPrivacyBloc.state is OneSignalPrivacyConsentSuccess) {
      oneSignalHealthBloc.add(OneSignalHealthCheck());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: AppDrawer(),
      floatingActionButton: _buildFloatingActionButton(
        context,
        _primaryConnectionAddressController,
        _deviceTokenController,
      ),
      body: BlocListener<RegisterDeviceBloc, RegisterDeviceState>(
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
            // Clear manual entry fields if registration succeeds
            _primaryConnectionAddressController.clear();
            _deviceTokenController.clear();

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
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SettingsAlertBanner(),
                  ),
                  SettingsHeader(
                    headingText: 'Tautulli Servers',
                  ),
                  state.serverList.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 10,
                          ),
                          child: ServerSetupInstructions(),
                        )
                      : Column(
                          children: state.serverList
                              .map(
                                (server) => ListTile(
                                  title: Text('${server.plexName}'),
                                  subtitle: isNotEmpty(
                                          server.primaryConnectionAddress)
                                      ? Text(server.primaryConnectionAddress)
                                      : Text(
                                          'Primary Connection Address Missing'),
                                  trailing: FaIcon(
                                    FontAwesomeIcons.cog,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ServerSettings(
                                            id: server.id,
                                            plexName: server.plexName,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                  // Display loading indicator when device is attemting to register
                  BlocBuilder<RegisterDeviceBloc, RegisterDeviceState>(
                    builder: (context, state) {
                      if (state is RegisterDeviceInProgress) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return Container(height: 0, width: 0);
                    },
                  ),
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
                    title: 'OneSignal Data Privacy',
                    icon: FaIcon(
                      FontAwesomeIcons.userSecret,
                      color: Colors.white,
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/privacy'),
                  ),
                  CustomSettingsTile(
                    title: 'Tautulli Remote Logs',
                    icon: FaIcon(
                      FontAwesomeIcons.solidListAlt,
                      color: Colors.white,
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/logs'),
                  ),
                ],
              );
            }
            if (state is SettingsLoadInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              //TODO: Handle if the settings state is something other than Loaded
              return Text('Something went wrong loading settings');
            }
          },
        ),
      ),
    );
  }
}

Widget _buildFloatingActionButton(
  BuildContext context,
  TextEditingController _primaryConnectionAddressController,
  TextEditingController _deviceTokenController,
) {
  final registerDeviceBloc = BlocProvider.of<RegisterDeviceBloc>(context);
  // ThemeData is required to correct bug in Speed Dial package where Icon color was fixed
  return Theme(
    data: ThemeData(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).accentColor,
      ),
    ),
    child: UnicornDialer(
      orientation: UnicornOrientation.VERTICAL,
      hasBackground: false,
      parentButton: Icon(Icons.add),
      childButtons: [
        UnicornButton(
          hasLabel: true,
          labelHasShadow: false,
          labelText: 'Enter manually',
          labelBackgroundColor: Colors.transparent,
          labelColor: Colors.white,
          currentButton: FloatingActionButton(
            heroTag: 'manual',
            mini: true,
            child: FaIcon(
              FontAwesomeIcons.pencilAlt,
              color: Colors.white,
            ),
            onPressed: () {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Manually register with Tautulli'),
                    content: SizedBox(
                      height: 130,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _primaryConnectionAddressController,
                            decoration:
                                InputDecoration(labelText: 'Tautulli Address'),
                          ),
                          TextFormField(
                            controller: _deviceTokenController,
                            decoration:
                                InputDecoration(labelText: 'Device Token'),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Register'),
                        onPressed: () {
                          registerDeviceBloc.add(
                            RegisterDeviceManualStarted(
                              connectionAddress:
                                  _primaryConnectionAddressController.text,
                              deviceToken: _deviceTokenController.text,
                              settingsBloc:
                                  BlocProvider.of<SettingsBloc>(context),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        UnicornButton(
          hasLabel: true,
          labelHasShadow: false,
          labelText: 'Scan QR code',
          labelBackgroundColor: Colors.transparent,
          labelColor: Colors.white,
          currentButton: FloatingActionButton(
            heroTag: 'scan',
            mini: true,
            child: FaIcon(
              FontAwesomeIcons.qrcode,
              color: Colors.white,
            ),
            onPressed: () async {
              final qrCodeScan = await FlutterBarcodeScanner.scanBarcode(
                '#e5a00d',
                'Cancel',
                false,
                ScanMode.QR,
              );
              // Scanner seems to return '-1' when scanner is exited
              // do not attempt to register when this happens
              if (qrCodeScan != '-1') {
                registerDeviceBloc.add(
                  RegisterDeviceFromQrStarted(
                    result: qrCodeScan,
                    // Passes in the SettingsBloc to maintain context so items update correctly
                    settingsBloc: BlocProvider.of<SettingsBloc>(context),
                  ),
                );
              }
            },
          ),
        ),
      ],
    ),
  );
}
