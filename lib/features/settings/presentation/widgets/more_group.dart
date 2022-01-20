import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'settings_group.dart';
import 'settings_list_tile.dart';

class MoreGroup extends StatelessWidget {
  const MoreGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      heading: 'More',
      settingsListTiles: [
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.userSecret),
          title: 'OneSignal Data Privacy',
          onTap: () {},
        ),
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.solidClipboard),
          title: 'Changelog',
          onTap: () {},
        ),
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.globe),
          title: 'Help Translate',
          onTap: () {
            Navigator.of(context).pushNamed('/help_translate');
          },
        ),
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.infoCircle),
          title: 'About',
          onTap: () {
            showAboutDialog(
              context: context,
              applicationIcon: SizedBox(
                height: 50,
                child: Image.asset('assets/logos/logo.png'),
              ),
              applicationName: 'Tautulli Remote',
              // applicationVersion: packageInfo.version, //TODO
              applicationLegalese:
                  'Licensed under the GNU General Public License v3.0',
            );
          },
        ),
      ],
    );
  }
}
