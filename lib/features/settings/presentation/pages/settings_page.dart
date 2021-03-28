import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:quiver/strings.dart';
import 'package:reorderables/reorderables.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_drawer_icon.dart';
import '../../../../core/widgets/double_tap_exit.dart';
import '../../../../core/widgets/failure_alert_dialog.dart';
import '../../../../core/widgets/list_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/activity_refresh_rate_dialog.dart';
import '../widgets/certificate_failure_alert_dialog.dart';
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

class SettingsPageContent extends StatefulWidget {
  const SettingsPageContent({Key key}) : super(key: key);

  @override
  _SettingsPageContentState createState() => _SettingsPageContentState();
}

class _SettingsPageContentState extends State<SettingsPageContent> {
  // ScrollController scrollController;
  // bool dialVisible = true;

  // @override
  // void initState() {
  //   super.initState();

  //   scrollController = ScrollController()
  //     ..addListener(() {
  //       setDialVisible(scrollController.position.userScrollDirection ==
  //           ScrollDirection.forward);
  //     });
  // }

  // void setDialVisible(bool value) {
  //   setState(() {
  //     dialVisible = value;
  //   });
  // }

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
      floatingActionButton: _buildSpeedDial(
        context,
        // dialVisible: dialVisible,
      ),
      body: DoubleTapExit(
        child: BlocListener<RegisterDeviceBloc, RegisterDeviceState>(
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
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
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
                  // controller: scrollController,
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
                        : ReorderableColumn(
                            onReorder: (oldIndex, newIndex) {
                              final int movedServerId =
                                  state.serverList[oldIndex].id;
                              context.read<SettingsBloc>().add(
                                    SettingsUpdateSortIndex(
                                      serverId: movedServerId,
                                      oldIndex: oldIndex,
                                      newIndex: newIndex,
                                    ),
                                  );
                            },
                            children: state.serverList
                                .map(
                                  (server) => ListTile(
                                    key: ValueKey(server.id),
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
                          builder: (context) => ServerTimeoutDialog(
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
                          builder: (context) => ActivityRefreshRateDialog(
                            initialValue: state.refreshRate == null
                                ? 0
                                : state.refreshRate,
                          ),
                        );
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Double Tap To Exit'),
                      subtitle: Text(
                        'Tap back twice to exit',
                      ),
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                              SettingsUpdateDoubleTapToExit(
                                value: value,
                              ),
                            );
                      },
                      value: state.doubleTapToExit ?? false,
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
                      onTap: () =>
                          Navigator.of(context).pushNamed('/changelog'),
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
    case (15):
      return Text('15 sec - Very Slow');
    case (30):
      return Text('30 sec - Extremely Slow');
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

Widget _buildSpeedDial(BuildContext context, {bool dialVisible = true}) {
  final registerDeviceBloc = context.read<RegisterDeviceBloc>();

  return BlocBuilder<SettingsBloc, SettingsState>(
    builder: (context, state) {
      if (state is SettingsLoadSuccess) {
        return SpeedDial(
          visible: dialVisible,
          curve: Curves.easeIn,
          icon: Icons.add,
          activeIcon: Icons.close,
          iconTheme: IconThemeData(
            color: TautulliColorPalette.not_white,
          ),
          backgroundColor: Theme.of(context).accentColor,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          children: [
            SpeedDialChild(
              backgroundColor: Theme.of(context).accentColor,
              labelWidget: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'Scan QR Code',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.qrcode,
                  color: TautulliColorPalette.not_white,
                  size: 20,
                ),
              ),
              onTap: () async {
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
                      settingsBloc: context.read<SettingsBloc>(),
                    ),
                  );
                }
              },
            ),
            SpeedDialChild(
              backgroundColor: Theme.of(context).accentColor,
              labelWidget: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'Enter Manually',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.pencilAlt,
                  color: TautulliColorPalette.not_white,
                  size: 19,
                ),
              ),
              onTap: () async {
                // Push manual registration page as a full screen dialog
                bool result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return BlocProvider(
                        create: (context) => di.sl<RegisterDeviceBloc>(),
                        child: ManualRegistrationForm(),
                      );
                    },
                  ),
                );

                // If manual registration page pops with true show success snackbar
                if (result == true) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Tautulli Registration Successful'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      }
      return const SizedBox(height: 0, width: 0);
    },
  );
}
