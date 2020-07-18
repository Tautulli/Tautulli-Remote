import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/color_palette_helper.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: PlexColorPalette.shark),
              child: Container(),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.tv,
                color: Colors.white,
              ),
              title: Text('Activity'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/activity');
              },
            ),
            // ListTile(
            //   leading: FaIcon(
            //     FontAwesomeIcons.history,
            //     color: Colors.white,
            //   ),
            //   title: Text('History'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: FaIcon(
            //     FontAwesomeIcons.clock,
            //     color: Colors.white,
            //   ),
            //   title: Text('Recently Added'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: FaIcon(
            //     FontAwesomeIcons.photoVideo,
            //     color: Colors.white,
            //   ),
            //   title: Text('Libraries'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: FaIcon(
            //     FontAwesomeIcons.users,
            //     color: Colors.white,
            //   ),
            //   title: Text('Users'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: FaIcon(
            //     FontAwesomeIcons.chartArea,
            //     color: Colors.white,
            //   ),
            //   title: Text('Statistics'),
            //   onTap: () {},
            // ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.cogs,
                color: Colors.white,
              ),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/settings');
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                color: PlexColorPalette.raven,
              ),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.userSecret,
                color: PlexColorPalette.gray_chateau,
              ),
              title: Text(
                'Privacy',
                style: TextStyle(
                  color: PlexColorPalette.gray_chateau,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/privacy');
              },
            ),
            //TODO: Help page
            // ListTile(
            //   leading: FaIcon(
            //     FontAwesomeIcons.solidQuestionCircle,
            //     color: PlexColorPalette.gray_chateau,
            //   ),
            //   title: Text(
            //     'Help',
            //     style: TextStyle(
            //       color: PlexColorPalette.gray_chateau,
            //     ),
            //   ),
            //   onTap: () {},
            // ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.infoCircle,
                color: PlexColorPalette.gray_chateau,
              ),
              title: Text(
                'About',
                style: TextStyle(
                  color: PlexColorPalette.gray_chateau,
                ),
              ),
              onTap: () {
                //TODO: Finish the about dialog
                showAboutDialog(
                  context: context,
                  // applicationIcon: FlutterLogo(),
                  applicationName: 'Tautulli Remote',
                  // applicationVersion: 'August 2019',
                  // applicationLegalese: '© 2014 The Flutter Authors',
                  children: <Widget>[],
                );
                // Navigator.of(context).pushNamed('/privacy');
              },
            ),
          ],
        ),
      ),
    );
  }
}
