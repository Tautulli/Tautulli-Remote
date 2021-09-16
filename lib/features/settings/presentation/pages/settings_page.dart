// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiver/strings.dart';
import 'package:reorderables/reorderables.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/failure_alert_dialog.dart';
import '../../../../core/widgets/inner_drawer_scaffold.dart';
import '../../../../core/widgets/list_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
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

    return InnerDrawerScaffold(
      title: Text(
        LocaleKeys.settings_page_title.tr(),
      ),
      body: SafeArea(
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
                  content:
                      const Text(LocaleKeys.settings_registration_success).tr(),
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
                    ListHeader(
                      headingText: LocaleKeys.settings_servers_heading.tr(),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state.serverList.isEmpty
                            // ignore: prefer_const_constructors
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 10,
                                ),
                                // ignore: prefer_const_constructors
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
                                                LocaleKeys
                                                    .settings_primary_connection_missing,
                                              ).tr()
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
                                                    : Text(
                                                        '*${LocaleKeys.masked_info_connection_address.tr()}*',
                                                      ),
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
                                          child: ServerRegistrationPage());
                                    },
                                  ),
                                );

                                if (result == true) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: const Text(
                                        LocaleKeys
                                            .settings_registration_success,
                                      ).tr(),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                LocaleKeys.button_register_server,
                              ).tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    //* App settings
                    ListHeader(
                      headingText:
                          LocaleKeys.settings_app_settings_heading.tr(),
                    ),
                    ListTile(
                      title:
                          const Text(LocaleKeys.settings_server_timeout).tr(),
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
                      title:
                          const Text(LocaleKeys.settings_activity_refresh_rate)
                              .tr(),
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
                    ListTile(
                      title: const Text(
                        LocaleKeys.advanced_settings_page_title,
                      ).tr(),
                      onTap: () => Navigator.of(context).pushNamed('/advanced'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.angleRight,
                        color: TautulliColorPalette.not_white,
                      ),
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
                        LocaleKeys.privacy_page_title,
                        style: TextStyle(
                          color: TautulliColorPalette.smoke,
                        ),
                      ).tr(),
                      trailing: const FaIcon(
                        FontAwesomeIcons.angleRight,
                        color: TautulliColorPalette.smoke,
                      ),
                      onTap: () => Navigator.of(context).pushNamed('/privacy'),
                    ),
                    ListTile(
                      title: const Text(
                        LocaleKeys.help_page_title,
                        style: TextStyle(
                          color: TautulliColorPalette.smoke,
                        ),
                      ).tr(),
                      trailing: const FaIcon(
                        FontAwesomeIcons.angleRight,
                        color: TautulliColorPalette.smoke,
                      ),
                      onTap: () => Navigator.of(context).pushNamed('/help'),
                    ),
                    ListTile(
                      title: const Text(
                        LocaleKeys.changelog_page_title,
                        style: TextStyle(
                          color: TautulliColorPalette.smoke,
                        ),
                      ).tr(),
                      trailing: const FaIcon(
                        FontAwesomeIcons.angleRight,
                        color: TautulliColorPalette.smoke,
                      ),
                      onTap: () =>
                          Navigator.of(context).pushNamed('/changelog'),
                    ),
                    ListTile(
                      title: const Text(
                        LocaleKeys.translate_page_title,
                        style: TextStyle(
                          color: TautulliColorPalette.smoke,
                        ),
                      ).tr(),
                      trailing: const FaIcon(
                        FontAwesomeIcons.angleRight,
                        color: TautulliColorPalette.smoke,
                      ),
                      onTap: () =>
                          Navigator.of(context).pushNamed('/translate'),
                    ),
                    ListTile(
                      title: const Text(
                        LocaleKeys.settings_about,
                        style: TextStyle(
                          color: TautulliColorPalette.smoke,
                        ),
                      ).tr(),
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
                              LocaleKeys.settings_about_license.tr(),
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
                    'There was an error loading settings.',
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
      return Text('3 ${LocaleKeys.general_details_sec.tr()}');
    case (5):
      return Text('5 ${LocaleKeys.general_details_sec.tr()}');
    case (8):
      return Text('8 ${LocaleKeys.general_details_sec.tr()}');
    case (30):
      return Text('30 ${LocaleKeys.general_details_sec.tr()}');
    default:
      return Text(
          '15 ${LocaleKeys.general_details_sec.tr()} (${LocaleKeys.settings_default.tr()})');
  }
}

Widget _serverRefreshRateDisplay(int refreshRate) {
  switch (refreshRate) {
    case (5):
      return Text(
          '5 ${LocaleKeys.general_details_sec.tr()} - ${LocaleKeys.settings_faster.tr()}');
    case (7):
      return Text(
          '7 ${LocaleKeys.general_details_sec.tr()} - ${LocaleKeys.settings_fast.tr()}');
    case (10):
      return Text(
          '10 ${LocaleKeys.general_details_sec.tr()} - ${LocaleKeys.settings_normal.tr()}');
    case (15):
      return Text(
          '15 ${LocaleKeys.general_details_sec.tr()} - ${LocaleKeys.settings_slow.tr()}');
    case (20):
      return Text(
          '20 ${LocaleKeys.general_details_sec.tr()} - ${LocaleKeys.settings_slower.tr()}');
    default:
      return const Text(LocaleKeys.settings_default).tr();
  }
}
