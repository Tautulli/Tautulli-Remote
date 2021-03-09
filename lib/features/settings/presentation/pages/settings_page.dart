import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:quiver/strings.dart';
import '../../../../core/error/failure.dart';
import '../widgets/certificate_failure_alert_dialog.dart';
import 'package:unicorndial/unicorndial.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_drawer_icon.dart';
import '../../../../core/widgets/failure_alert_dialog.dart';
import '../../../../core/widgets/list_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/activity_refresh_rate_dialog.dart';
import '../widgets/server_setup_instructions.dart';
import '../widgets/server_timeout_dialog.dart';
import '../widgets/settings_alert_banner.dart';
import 'manual_registration_form_page.dart';
import 'server_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    context.read<SettingsBloc>();
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
    final oneSignalPrivacyBloc = context.read<OneSignalPrivacyBloc>();
    final oneSignalHealthBloc = context.read<OneSignalHealthBloc>();

    if (oneSignalPrivacyBloc.state is OneSignalPrivacyConsentSuccess) {
      oneSignalHealthBloc.add(OneSignalHealthCheck());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: AppDrawerIcon(),
        title: Text('Settings'),
      ),
      drawer: AppDrawer(),
      floatingActionButton: _buildFloatingActionButton(context),
      body: BlocListener<RegisterDeviceBloc, RegisterDeviceState>(
        listener: (context, state) {
          if (state is RegisterDeviceFailure) {
            if (state.failure == CertificateVerificationFailure()) {
              showCertificateFailureAlertDialog(
                  context: context,
                  registerDeviceBloc: context.read<RegisterDeviceBloc>(),
                  settingsBloc: context.read<SettingsBloc>());
            } else {
              showFailureAlertDialog(
                context: context,
                failure: state.failure,
              );
            }
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
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SettingsAlertBanner(),
                  ),
                  ListHeader(
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
                                  subtitle: (isEmpty(
                                          server.primaryConnectionAddress))
                                      ? Text(
                                          'Primary Connection Address Missing')
                                      : isNotEmpty(server
                                                  .primaryConnectionAddress) &&
                                              server.primaryActive &&
                                              !state.maskSensitiveInfo
                                          ? Text(
                                              server.primaryConnectionAddress)
                                          : isNotEmpty(server
                                                      .primaryConnectionAddress) &&
                                                  !server.primaryActive &&
                                                  !state.maskSensitiveInfo
                                              ? Text(server
                                                  .secondaryConnectionAddress)
                                              : Text(
                                                  '*Hidden Connection Address*'),
                                  trailing: FaIcon(
                                    FontAwesomeIcons.cog,
                                    color: TautulliColorPalette.not_white,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ServerSettingsPage(
                                            id: server.id,
                                            plexName: server.plexName,
                                            maskSensitiveInfo:
                                                state.maskSensitiveInfo,
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
                            padding: const EdgeInsets.only(top: 6, bottom: 8),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return SizedBox(height: 0, width: 0);
                    },
                  ),
                  SizedBox(height: 20),
                  //* App settings
                  ListHeader(
                    headingText: 'App Settings',
                  ),
                  ListTile(
                    title: Text('Server Timeout'),
                    subtitle: _serverTimeoutDisplay(state.serverTimeout),
                    onTap: () {
                      return showDialog(
                        context: context,
                        child: ServerTimeoutDialog(
                          initialValue: state.serverTimeout == null
                              ? 5
                              : state.serverTimeout,
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Activity Refresh Rate'),
                    subtitle: _serverRefreshRateDisplay(state.refreshRate),
                    onTap: () {
                      return showDialog(
                        context: context,
                        child: ActivityRefreshRateDialog(
                          initialValue:
                              state.refreshRate == null ? 0 : state.refreshRate,
                        ),
                      );
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Mask Sensitive Info'),
                    subtitle: Text('Hides sensitive info in the UI'),
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                            SettingsUpdateMaskSensitiveInfo(
                              value: value,
                            ),
                          );
                    },
                    value: state.maskSensitiveInfo ?? false,
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
                  ListTile(
                    title: Text(
                      'OneSignal Data Privacy',
                      style: TextStyle(
                        color: TautulliColorPalette.smoke,
                      ),
                    ),
                    trailing: FaIcon(
                      FontAwesomeIcons.angleRight,
                      color: TautulliColorPalette.smoke,
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/privacy'),
                  ),
                  ListTile(
                    title: Text(
                      'Help & Support',
                      style: TextStyle(
                        color: TautulliColorPalette.smoke,
                      ),
                    ),
                    trailing: FaIcon(
                      FontAwesomeIcons.angleRight,
                      color: TautulliColorPalette.smoke,
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/help'),
                  ),
                  ListTile(
                    title: Text(
                      'Changelog',
                      style: TextStyle(
                        color: TautulliColorPalette.smoke,
                      ),
                    ),
                    trailing: FaIcon(
                      FontAwesomeIcons.angleRight,
                      color: TautulliColorPalette.smoke,
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/changelog'),
                  ),
                  ListTile(
                    title: Text(
                      'About',
                      style: TextStyle(
                        color: TautulliColorPalette.smoke,
                      ),
                    ),
                    trailing: FaIcon(
                      FontAwesomeIcons.angleRight,
                      color: TautulliColorPalette.smoke,
                    ),
                    onTap: () async {
                      PackageInfo packageInfo =
                          await PackageInfo.fromPlatform();
                      showAboutDialog(
                        context: context,
                        applicationIcon: SizedBox(
                          height: 50,
                          child: Image.asset('assets/logo/logo.png'),
                        ),
                        applicationName: 'Tautulli Remote',
                        applicationVersion: packageInfo.version,
                        applicationLegalese:
                            'Licensed under the GNU General Public License v3.0',
                      );
                    },
                  ),
                ],
              );
            }
            if (state is SettingsLoadInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Text(
                  'There was an error loading settings. Please use the help page to get assistance.',
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

Widget _serverTimeoutDisplay(int timeout) {
  switch (timeout) {
    case (3):
      return Text('3 sec - Fast');
    case (8):
      return Text('8 sec - Slow');
    default:
      return Text('5 sec - Default');
  }
}

Widget _serverRefreshRateDisplay(int refreshRate) {
  switch (refreshRate) {
    case (5):
      return Text('5 sec - Faster');
    case (7):
      return Text('7 sec - Fast');
    case (10):
      return Text('10 sec - Normal');
    case (15):
      return Text('15 sec - Slow');
    case (20):
      return Text('20 sec - Slower');
    default:
      return Text('Disabled');
  }
}

Widget _buildFloatingActionButton(
  BuildContext context,
) {
  final registerDeviceBloc = context.read<RegisterDeviceBloc>();
  // ThemeData is required to correct bug in Speed Dial package where Icon color was fixed
  return Builder(
    builder: (context) {
      return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoadSuccess) {
            return Theme(
              data: ThemeData(
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  foregroundColor: TautulliColorPalette.not_white,
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
              child: UnicornDialer(
                orientation: UnicornOrientation.VERTICAL,
                hasBackground: false,
                parentButton: Icon(
                  Icons.add,
                  color: TautulliColorPalette.not_white,
                ),
                childButtons: [
                  UnicornButton(
                    hasLabel: true,
                    labelHasShadow: false,
                    labelText: 'Enter manually',
                    labelBackgroundColor: Colors.transparent,
                    labelColor: TautulliColorPalette.not_white,
                    currentButton: FloatingActionButton(
                      heroTag: 'manual',
                      mini: true,
                      child: FaIcon(
                        FontAwesomeIcons.pencilAlt,
                        color: TautulliColorPalette.not_white,
                      ),
                      onPressed: () async {
                        // Push manual registration page as a full screen dialog
                        bool result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) {
                              return BlocProvider(
                                create: (context) =>
                                    di.sl<RegisterDeviceBloc>(),
                                child: ManualRegistrationForm(),
                              );
                            },
                          ),
                        );

                        // If manual registration page pops with true show success snackbar
                        if (result == true) {
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Tautulli Registration Successful'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  UnicornButton(
                    hasLabel: true,
                    labelHasShadow: false,
                    labelText: 'Scan QR code',
                    labelBackgroundColor: Colors.transparent,
                    labelColor: TautulliColorPalette.not_white,
                    currentButton: FloatingActionButton(
                      heroTag: 'scan',
                      mini: true,
                      child: FaIcon(
                        FontAwesomeIcons.qrcode,
                        color: TautulliColorPalette.not_white,
                      ),
                      onPressed: () async {
                        final qrCodeScan =
                            await FlutterBarcodeScanner.scanBarcode(
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
                              settingsBloc: context.read<SettingsBloc>(),
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
          return const SizedBox(height: 0, width: 0);
        },
      );
    },
  );
}
