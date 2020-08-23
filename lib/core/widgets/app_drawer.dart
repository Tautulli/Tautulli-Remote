import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                          child:
                              Image.asset('assets/logo/logo_transparent.png'),
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
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.history,
                color: TautulliColorPalette.not_white,
              ),
              title: Text('History'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/history');
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.clock,
                color: TautulliColorPalette.not_white,
              ),
              title: Text('Recently Added'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/recent');
              },
            ),
            // ListTile(
            //   leading: FaIcon(
            //     FontAwesomeIcons.photoVideo,
            //     color: TautulliColorPalette.not_white,
            //   ),
            //   title: Text('Libraries'),
            //   onTap: () {},
            // ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.users,
                color: TautulliColorPalette.not_white,
              ),
              title: Text('Users'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/users');
              },
            ),
            // ListTile(
            //   leading: FaIcon(
            //     FontAwesomeIcons.chartArea,
            //     color: TautulliColorPalette.not_white,
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 25),
            //   child: Divider(
            //     color: PlexColorPalette.raven,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
