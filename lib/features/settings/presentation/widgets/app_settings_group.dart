import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/settings_bloc.dart';
import '../pages/advanced_page.dart';
import 'activity_refresh_rate_dialog.dart';
import 'server_timeout_dialog.dart';
import 'settings_group.dart';
import 'settings_list_tile.dart';

class AppSettingsGroup extends StatelessWidget {
  const AppSettingsGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      heading: 'Settings & Operations',
      settingsListTiles: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final serverTimeout = state.appSettings.serverTimeout;

            return SettingsListTile(
              leading: const FaIcon(
                FontAwesomeIcons.stopwatch,
                size: 28,
              ),
              title: 'Server Timeout',
              subtitle: _serverTimeoutDisplay(serverTimeout),
              onTap: () async => await showDialog(
                context: context,
                builder: (context) => ServerTimeoutDialog(
                  initialValue: serverTimeout,
                ),
              ),
            );
          },
        ),
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.solidClock),
          title: 'Activity Refresh Rate',
          subtitle: 'Disabled',
          onTap: () async => await showDialog(
            context: context,
            builder: (context) => const ActivityRefreshRateDialog(),
          ),
        ),
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.wrench),
          title: 'Advanced',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdvancedPage(),
            ),
          ),
        ),
      ],
    );
  }
}

String _serverTimeoutDisplay(int timeout) {
  switch (timeout) {
    case (3):
      return '3 sec';
    case (5):
      return '5 sec';
    case (8):
      return '8 sec';
    case (30):
      return '30 sec';
    default:
      return '15 sec (Default)';
  }
}
