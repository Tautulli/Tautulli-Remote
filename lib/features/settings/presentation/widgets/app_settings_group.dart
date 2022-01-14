import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'settings_group.dart';
import 'settings_list_tile.dart';

class AppSettingsGroup extends StatelessWidget {
  const AppSettingsGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsGroup(
      heading: 'App Settings',
      settingsListTiles: [
        SettingsListTile(
          leading: FaIcon(
            FontAwesomeIcons.stopwatch,
            size: 28,
          ),
          title: 'Server Timeout',
          subtitle: '15 sec (Default)',
        ),
        SettingsListTile(
          leading: FaIcon(FontAwesomeIcons.solidClock),
          title: 'Activity Refresh Rate',
          subtitle: 'Disabled',
        ),
        SettingsListTile(
          leading: FaIcon(FontAwesomeIcons.cogs),
          title: 'Advanced Settings',
        ),
      ],
    );
  }
}
