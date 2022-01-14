import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'settings_group.dart';
import 'settings_list_tile.dart';

class MoreGroup extends StatelessWidget {
  const MoreGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsGroup(
      heading: 'More',
      settingsListTiles: [
        SettingsListTile(
          leading: FaIcon(FontAwesomeIcons.userSecret),
          title: 'OneSignal Data Privacy',
        ),
        SettingsListTile(
          leading: FaIcon(FontAwesomeIcons.solidClipboard),
          title: 'Changelog',
        ),
        SettingsListTile(
          leading: FaIcon(FontAwesomeIcons.globe),
          title: 'Help Translate',
        ),
        SettingsListTile(
          leading: FaIcon(FontAwesomeIcons.infoCircle),
          title: 'About',
        ),
      ],
    );
  }
}
