import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';

import '../helpers/color_palette_helper.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: PlexColorPalette.shark),
        child: ListView(
          children: <Widget>[
            Container(
              height: 100,
              decoration: BoxDecoration(color: TautulliColorPalette.midnight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 70,
                          padding: const EdgeInsets.only(right: 3),
                          child: Image.asset('assets/logo/logo_transparent.png'),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Tautulli',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Remote',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.tv,
                color: TautulliColorPalette.not_white,
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
                color: TautulliColorPalette.not_white,
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
              onTap: () async {
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                showAboutDialog(
                  context: context,
                  applicationIcon: SizedBox(
                    height: 50,
                    child: Image.asset('assets/logo/logo.png'),
                  ),
                  applicationName: 'Tautulli Remote',
                  applicationVersion: packageInfo.version,
                  applicationLegalese:
                      'Licensed under the GNU General Public License v3.0',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
