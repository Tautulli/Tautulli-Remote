import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/advanced_settings_page.dart';
import 'activity_refresh_rate_dialog.dart';
import 'server_timeout_dialog.dart';
import 'settings_group.dart';
import 'settings_list_tile.dart';

class AppSettingsGroup extends StatelessWidget {
  const AppSettingsGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      heading: 'App Settings',
      settingsListTiles: [
        SettingsListTile(
          leading: const FaIcon(
            FontAwesomeIcons.stopwatch,
            size: 28,
          ),
          title: 'Server Timeout',
          subtitle: '15 sec (Default)',
          onTap: () async => await showDialog(
            context: context,
            builder: (context) => const ServerTimeoutDialog(),
          ),
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
          leading: const FaIcon(FontAwesomeIcons.cogs),
          title: 'Advanced Settings',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdvancedSettingsPage(),
            ),
          ),
        ),
      ],
    );
  }
}
