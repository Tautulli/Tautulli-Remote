import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/list_tile_group.dart';
import 'settings_list_tile.dart';

class HelpAndSupportGroup extends StatelessWidget {
  const HelpAndSupportGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: 'Help & Support',
      listTiles: [
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.github),
          title: 'Wiki',
          onTap: () async {
            await launch('https://github.com/Tautulli/Tautulli-Remote/wiki');
          },
        ),
        SettingsListTile(
          leading: const FaIcon(
            FontAwesomeIcons.discord,
            size: 22,
          ),
          title: 'Discord',
          onTap: () async {
            await launch('https://tautulli.com/discord.html');
          },
        ),
        SettingsListTile(
          leading: const FaIcon(
            FontAwesomeIcons.redditAlien,
            size: 28,
          ),
          title: 'Reddit',
          onTap: () async {
            await launch('https://www.reddit.com/r/Tautulli/');
          },
        ),
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.github),
          title: 'Bugs/Feature Requests',
          onTap: () async {
            await launch('https://github.com/Tautulli/Tautulli-Remote/issues');
          },
        ),
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.list),
          title: 'Tautulli Remote Logs',
          onTap: () {},
        ),
      ],
    );
  }
}
