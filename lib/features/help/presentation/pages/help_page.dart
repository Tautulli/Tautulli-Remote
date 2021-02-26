import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/list_header.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key key}) : super(key: key);

  static const routeName = '/help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      //TODO: Build out help topics
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView(
          children: [
            ListHeader(headingText: 'Help Topics'),
            ListTile(
              title: Text('Secondary Connection Address'),
              trailing: FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Settings#secondary_connection',
                );
              },
            ),
            ListTile(
              title: Text('Using Basic Authentication'),
              trailing: FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Settings#basic_authentication',
                );
              },
            ),
            ListTile(
              title: Text('Terminating a Stream'),
              trailing: FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () {
                launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#terminating_stream',
                );
              },
            ),
            const SizedBox(height: 15),
            ListHeader(headingText: 'Support'),
            ListTile(
              title: Text('Wiki'),
              trailing: FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Settings#basic_authentication',
                );
              },
            ),
            ListTile(
              title: Text('Discord'),
              trailing: FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                launch('https://tautulli.com/discord.html');
              },
            ),
            ListTile(
              title: Text('Reddit'),
              trailing: FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                launch('https://www.reddit.com/r/Tautulli/');
              },
            ),
            const SizedBox(height: 15),
            ListHeader(headingText: 'Logs'),
            ListTile(
              title: Text('View Tautulli Remote logs'),
              trailing: FaIcon(
                FontAwesomeIcons.angleRight,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () => Navigator.of(context).pushNamed('/logs'),
            ),
          ],
        ),
      ),
    );
  }
}
