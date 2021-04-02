import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features/activity/presentation/pages/activity_page.dart';
import '../../features/announcements/presentation/bloc/announcements_bloc.dart';
import '../../features/announcements/presentation/pages/announcements_page.dart';
import '../../features/donate/presentation/pages/donate_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/libraries/presentation/pages/libraries_page.dart';
import '../../features/recent/presentation/pages/recently_added_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../../features/synced_items/presentation/pages/synced_items_page.dart';
import '../../features/users/presentation/pages/users_page.dart';
import '../helpers/color_palette_helper.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context).settings.name;

    return Drawer(
      child: Column(
        children: [
          // Add colored bar behind status bar
          Container(
            height: MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(color: TautulliColorPalette.midnight),
          ),
          // Logo section
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
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 0),
              children: <Widget>[
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.tv,
                    size: 20,
                    color: TautulliColorPalette.not_white,
                  ),
                  title: Text('Activity'),
                  onTap: () {
                    if (currentRoute != ActivityPage.routeName &&
                        currentRoute != '/') {
                      Navigator.of(context)
                          .pushReplacementNamed(ActivityPage.routeName);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.history,
                    size: 20,
                    color: TautulliColorPalette.not_white,
                  ),
                  title: Text('History'),
                  onTap: () {
                    _pushRoute(
                      context: context,
                      currentRoute: currentRoute,
                      namedRoute: HistoryPage.routeName,
                    );
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.clock,
                    size: 20,
                    color: TautulliColorPalette.not_white,
                  ),
                  title: Text('Recently Added'),
                  onTap: () {
                    _pushRoute(
                      context: context,
                      currentRoute: currentRoute,
                      namedRoute: RecentlyAddedPage.routeName,
                    );
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.photoVideo,
                    size: 20,
                    color: TautulliColorPalette.not_white,
                  ),
                  title: Text('Libraries'),
                  onTap: () {
                    _pushRoute(
                      context: context,
                      currentRoute: currentRoute,
                      namedRoute: LibrariesPage.routeName,
                    );
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.users,
                    size: 20,
                    color: TautulliColorPalette.not_white,
                  ),
                  title: Text('Users'),
                  onTap: () {
                    _pushRoute(
                      context: context,
                      currentRoute: currentRoute,
                      namedRoute: UsersPage.routeName,
                    );
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.listOl,
                    size: 20,
                    color: TautulliColorPalette.not_white,
                  ),
                  title: Text('Statistics'),
                  onTap: () {
                    _pushRoute(
                      context: context,
                      currentRoute: currentRoute,
                      namedRoute: StatisticsPage.routeName,
                    );
                  },
                ),
                // ListTile(
                //   leading: FaIcon(
                //     FontAwesomeIcons.chartBar,
                //     size: 20,
                //     color: TautulliColorPalette.not_white,
                //   ),
                //   title: Text('Graphs'),
                //   onTap: () {
                //     // if (currentRoute != StatisticsPage.routeName) {
                //     //   Navigator.of(context)
                //     //       .pushReplacementNamed(StatisticsPage.routeName);
                //     // } else {
                //     //   Navigator.pop(context);
                //     // }
                //   },
                //   onLongPress: () {
                //     // Navigator.of(context)
                //     //     .pushReplacementNamed(StatisticsPage.routeName);
                //   },
                // ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.cloudDownloadAlt,
                    size: 20,
                    color: TautulliColorPalette.not_white,
                  ),
                  title: Text('Synced Items'),
                  onTap: () {
                    _pushRoute(
                      context: context,
                      currentRoute: currentRoute,
                      namedRoute: SyncedItemsPage.routeName,
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: PlexColorPalette.raven,
            ),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.bullhorn,
              size: 20,
              color: TautulliColorPalette.not_white,
            ),
            title: Text('Announcements'),
            onTap: () {
              if (currentRoute != AnnouncementsPage.routeName) {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(AnnouncementsPage.routeName);
              } else {
                Navigator.pop(context);
              }
            },
            trailing: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
              builder: (context, state) {
                if (state is AnnouncementsSuccess && state.unread) {
                  return Container(
                    height: 13,
                    width: 13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PlexColorPalette.gamboge,
                    ),
                  );
                }
                return SizedBox(height: 0, width: 0);
              },
            ),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.solidHeart,
              size: 20,
              color: Colors.red[400],
            ),
            title: Text('Donate'),
            onTap: () {
              if (currentRoute != DonatePage.routeName) {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(DonatePage.routeName);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.cogs,
              size: 20,
              color: TautulliColorPalette.not_white,
            ),
            title: Text('Settings'),
            onTap: () {
              _pushRoute(
                context: context,
                currentRoute: currentRoute,
                namedRoute: SettingsPage.routeName,
              );
            },
          ),
        ],
      ),
    );
  }
}

void _pushRoute({
  @required BuildContext context,
  @required String currentRoute,
  @required String namedRoute,
}) {
  if (currentRoute == ActivityPage.routeName || currentRoute == '/') {
    Navigator.pop(context);
    Navigator.of(context).pushNamed(namedRoute);
  } else if (currentRoute != namedRoute) {
    Navigator.of(context).pushReplacementNamed(namedRoute);
  } else {
    Navigator.pop(context);
  }
}
