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
              title: Text('OneSignal authentication'),
              trailing: FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text('Basic authentication'),
              trailing: FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text('Terminating a stream'),
              trailing: FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () {},
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
              onTap: () {},
            ),
            ListTile(
              title: Text('Discord'),
              trailing: FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () {
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
              onTap: () {
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
