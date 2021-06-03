import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
import 'server_registration_page.dart';
import 'server_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    context.read<SettingsBloc>();
    return BlocProvider(
      create: (context) => di.sl<RegisterDeviceBloc>(),
      child: const SettingsPageContent(),
    );
  }
}

class SettingsPageContent extends StatefulWidget {
  const SettingsPageContent({Key key}) : super(key: key);

  @override
  _SettingsPageContentState createState() => _SettingsPageContentState();
}

class _SettingsPageContentState extends State<SettingsPageContent> {
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
        leading: const AppDrawerIcon(),
        title: const Text('Settings'),
      ),
      drawer: const AppDrawer(),
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
                const SnackBar(
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: SettingsAlertBanner(),
                    ),
                    const ListHeader(
                      headingText: 'Tautulli Servers',
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state.serverList.isEmpty
                            ? const Padding(
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
                                        subtitle: (isEmpty(server
                                                .primaryConnectionAddress))
                                            ? const Text(
                                                'Primary Connection Address Missing')
                                            : isNotEmpty(server
                                                        .primaryConnectionAddress) &&
                                                    server.primaryActive &&
                                                    !state.maskSensitiveInfo
                                                ? Text(server
                                                    .primaryConnectionAddress)
                                                : isNotEmpty(server
                                                            .primaryConnectionAddress) &&
                                                        !server.primaryActive &&
                                                        !state.maskSensitiveInfo
                                                    ? Text(server
                                                        .secondaryConnectionAddress)
                                                    : const Text(
                                                        '*Hidden Connection Address*'),
                                        trailing: const FaIcon(
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
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: state.serverList.isEmpty ? 8 : 0,
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).accentColor,
                              ),
                              onPressed: () async {
                                bool result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) {
                                      return BlocProvider(
                                        create: (context) =>
                                            di.sl<RegisterDeviceBloc>(),
                                        child: ServerRegistrationPage(),
                                      );
                                    },
                                  ),
                                );

                                if (result == true) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                          'Tautulli Registration Successful'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Register a Tautulli Server'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    //* App settings
                    const ListHeader(
                      headingText: 'App Settings',
                    ),
                    ListTile(
                      title: const Text('Server Timeout'),
                      subtitle: _serverTimeoutDisplay(state.serverTimeout),
                      onTap: () {
                        return showDialog(
                          context: context,
                          builder: (context) => ServerTimeoutDialog(
                            initialValue: state.serverTimeout,
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Activity Refresh Rate'),
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
                      title: const Text('Double Tap To Exit'),
                      subtitle: const Text(
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
                      title: const Text('Mask Sensitive Info'),
                      subtitle: const Text('Hides sensitive info in the UI'),
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
                      title: const Text(
                        'OneSignal Data Privacy',
                        style: TextStyle(
                          color: TautulliColorPalette.smoke,
                        ),
                      ),
                      trailing: const FaIcon(
                        FontAwesomeIcons.angleRight,
                        color: TautulliColorPalette.smoke,
                      ),
                      onTap: () => Navigator.of(context).pushNamed('/privacy'),
                    ),
                    ListTile(
                      title: const Text(
                        'Help & Support',
                        style: TextStyle(
                          color: TautulliColorPalette.smoke,
                        ),
                      ),
                      trailing: const FaIcon(
                        FontAwesomeIcons.angleRight,
                        color: TautulliColorPalette.smoke,
                      ),
                      onTap: () => Navigator.of(context).pushNamed('/help'),
                    ),
                    ListTile(
                      title: const Text(
                        'Changelog',
                        style: TextStyle(
                          color: TautulliColorPalette.smoke,
                        ),
                      ),
                      trailing: const FaIcon(
                        FontAwesomeIcons.angleRight,
                        color: TautulliColorPalette.smoke,
                      ),
                      onTap: () =>
                          Navigator.of(context).pushNamed('/changelog'),
                    ),
                    ListTile(
                      title: const Text(
                        'About',
                        style: TextStyle(
                          color: TautulliColorPalette.smoke,
                        ),
                      ),
                      trailing: const FaIcon(
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
                  child: CircularProgressIndicator(
                    color: Theme.of(context).accentColor,
                  ),
                );
              } else {
                return const Center(
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
      return const Text('3 sec');
    case (5):
      return const Text('5 sec');
    case (8):
      return const Text('8 sec');
    case (30):
      return const Text('30 sec');
    default:
      return const Text('15 sec (Default)');
  }
}

Widget _serverRefreshRateDisplay(int refreshRate) {
  switch (refreshRate) {
    case (5):
      return const Text('5 sec - Faster');
    case (7):
      return const Text('7 sec - Fast');
    case (10):
      return const Text('10 sec - Normal');
    case (15):
      return const Text('15 sec - Slow');
    case (20):
      return const Text('20 sec - Slower');
    default:
      return const Text('Disabled');
  }
}
