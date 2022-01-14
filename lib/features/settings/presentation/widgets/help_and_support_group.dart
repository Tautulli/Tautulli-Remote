import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'settings_group.dart';
import 'settings_list_tile.dart';

class HelpAndSupportGroup extends StatelessWidget {
  const HelpAndSupportGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsGroup(
      heading: 'Help & Support',
      settingsListTiles: [
        SettingsListTile(
          leading: FaIcon(FontAwesomeIcons.github),
          title: 'Wiki',
        ),
        SettingsListTile(
          leading: FaIcon(
            FontAwesomeIcons.discord,
            size: 22,
          ),
          title: 'Discord',
        ),
        SettingsListTile(
          leading: FaIcon(
            FontAwesomeIcons.redditAlien,
            size: 28,
          ),
          title: 'Reddit',
        ),
        SettingsListTile(
          leading: FaIcon(FontAwesomeIcons.github),
          title: 'Bugs/Feature Requests',
        ),
        SettingsListTile(
          leading: FaIcon(FontAwesomeIcons.list),
          title: 'Tautulli Remote Logs',
        ),
      ],
    );
  }
}
