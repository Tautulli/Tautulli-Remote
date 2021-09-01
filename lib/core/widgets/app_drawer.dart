// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features/activity/presentation/pages/activity_page.dart';
import '../../features/announcements/presentation/bloc/announcements_bloc.dart';
import '../../features/announcements/presentation/pages/announcements_page.dart';
import '../../features/donate/presentation/pages/donate_page.dart';
import '../../features/graphs/presentation/pages/graphs_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/libraries/presentation/pages/libraries_page.dart';
import '../../features/recent/presentation/pages/recently_added_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../../features/synced_items/presentation/pages/synced_items_page.dart';
import '../../features/users/presentation/pages/users_page.dart';
import '../../translations/locale_keys.g.dart';
import '../helpers/color_palette_helper.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);

    return Drawer(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Add colored bar behind status bar
            Container(
              height: MediaQuery.of(context).padding.top,
              decoration:
                  const BoxDecoration(color: TautulliColorPalette.midnight),
            ),
            // Logo section
            Container(
              height: 100,
              decoration:
                  const BoxDecoration(color: TautulliColorPalette.midnight),
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
                          text: const TextSpan(
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
              child: Column(
                children: [
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        children: [
                          ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.tv,
                              size: 20,
                              color: TautulliColorPalette.not_white,
                            ),
                            title: Text(
                              LocaleKeys.activity_page_title.tr(),
                            ),
                            onTap: () {
                              if (route.settings.name !=
                                      ActivityPage.routeName &&
                                  route.settings.name != '/') {
                                Navigator.of(context).pushReplacementNamed(
                                    ActivityPage.routeName);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            onLongPress: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(ActivityPage.routeName);
                            },
                          ),
                          ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.history,
                              size: 20,
                              color: TautulliColorPalette.not_white,
                            ),
                            title:
                                const Text(LocaleKeys.history_page_title).tr(),
                            onTap: () {
                              if (route.settings.name !=
                                  HistoryPage.routeName) {
                                Navigator.of(context).pushReplacementNamed(
                                    HistoryPage.routeName);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            onLongPress: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(HistoryPage.routeName);
                            },
                          ),
                          ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.clock,
                              size: 20,
                              color: TautulliColorPalette.not_white,
                            ),
                            title: Text(
                              LocaleKeys.recently_added_page_title.tr(),
                            ),
                            onTap: () {
                              if (route.settings.name !=
                                  RecentlyAddedPage.routeName) {
                                Navigator.of(context).pushReplacementNamed(
                                    RecentlyAddedPage.routeName);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            onLongPress: () {
                              Navigator.of(context).pushReplacementNamed(
                                  RecentlyAddedPage.routeName);
                            },
                          ),
                          ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.photoVideo,
                              size: 20,
                              color: TautulliColorPalette.not_white,
                            ),
                            title: Text(
                              LocaleKeys.libraries_page_title.tr(),
                            ),
                            onTap: () {
                              if (route.settings.name !=
                                  LibrariesPage.routeName) {
                                Navigator.of(context).pushReplacementNamed(
                                    LibrariesPage.routeName);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            onLongPress: () {
                              Navigator.of(context).pushReplacementNamed(
                                  LibrariesPage.routeName);
                            },
                          ),
                          ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.users,
                              size: 20,
                              color: TautulliColorPalette.not_white,
                            ),
                            title: Text(
                              LocaleKeys.users_page_title.tr(),
                            ),
                            onTap: () {
                              if (route.settings.name != UsersPage.routeName) {
                                Navigator.of(context)
                                    .pushReplacementNamed(UsersPage.routeName);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            onLongPress: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(UsersPage.routeName);
                            },
                          ),
                          ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.listOl,
                              size: 20,
                              color: TautulliColorPalette.not_white,
                            ),
                            title: Text(
                              LocaleKeys.statistics_page_title.tr(),
                            ),
                            onTap: () {
                              if (route.settings.name !=
                                  StatisticsPage.routeName) {
                                Navigator.of(context).pushReplacementNamed(
                                    StatisticsPage.routeName);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            onLongPress: () {
                              Navigator.of(context).pushReplacementNamed(
                                  StatisticsPage.routeName);
                            },
                          ),
                          ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.chartBar,
                              size: 20,
                              color: TautulliColorPalette.not_white,
                            ),
                            title: Text(
                              LocaleKeys.graphs_page_title.tr(),
                            ),
                            onTap: () {
                              if (route.settings.name != GraphsPage.routeName) {
                                Navigator.of(context)
                                    .pushReplacementNamed(GraphsPage.routeName);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            onLongPress: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(GraphsPage.routeName);
                            },
                          ),
                          ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.cloudDownloadAlt,
                              size: 20,
                              color: TautulliColorPalette.not_white,
                            ),
                            title: Text(
                              LocaleKeys.synced_items_page_title.tr(),
                            ),
                            onTap: () {
                              if (route.settings.name !=
                                  SyncedItemsPage.routeName) {
                                Navigator.of(context).pushReplacementNamed(
                                    SyncedItemsPage.routeName);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            onLongPress: () {
                              Navigator.of(context).pushReplacementNamed(
                                  SyncedItemsPage.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(
                      color: PlexColorPalette.raven,
                    ),
                  ),
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.bullhorn,
                      size: 20,
                      color: TautulliColorPalette.not_white,
                    ),
                    title: Text(
                      LocaleKeys.announcements_page_title.tr(),
                    ),
                    onTap: () {
                      if (route.settings.name != AnnouncementsPage.routeName) {
                        Navigator.of(context)
                            .pushNamed(AnnouncementsPage.routeName);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    onLongPress: () {
                      Navigator.pop(context);
                      Navigator.of(context)
                          .pushNamed(AnnouncementsPage.routeName);
                    },
                    trailing:
                        BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
                      builder: (context, state) {
                        if (state is AnnouncementsSuccess && state.unread) {
                          return Container(
                            height: 13,
                            width: 13,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: PlexColorPalette.gamboge,
                            ),
                          );
                        }
                        return const SizedBox(height: 0, width: 0);
                      },
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.solidHeart,
                      size: 20,
                      color: Colors.red[400],
                    ),
                    title: Text(
                      LocaleKeys.donate_page_title.tr(),
                    ),
                    onTap: () {
                      if (route.settings.name != DonatePage.routeName) {
                        Navigator.of(context).pushNamed(DonatePage.routeName);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    onLongPress: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(DonatePage.routeName);
                    },
                  ),
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.cogs,
                      size: 20,
                      color: TautulliColorPalette.not_white,
                    ),
                    title: Text(
                      LocaleKeys.settings_page_title.tr(),
                    ),
                    onTap: () {
                      if (route.settings.name != SettingsPage.routeName) {
                        Navigator.of(context)
                            .pushReplacementNamed(SettingsPage.routeName);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    onLongPress: () {
                      Navigator.of(context)
                          .pushReplacementNamed(SettingsPage.routeName);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
