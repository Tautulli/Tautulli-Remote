import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../features/announcements/presentation/bloc/announcements_bloc.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../translations/locale_keys.g.dart';
import '../database/data/models/server_model.dart';
import 'double_back_to_exit.dart';
import 'drawer_icon_button.dart';
import 'drawer_tile.dart';
import 'page_body.dart';
import 'tautulli_logo_title.dart';

class ScaffoldWithInnerDrawer extends StatelessWidget {
  final Widget title;
  final Widget body;
  final List<Widget>? actions;

  const ScaffoldWithInnerDrawer({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<InnerDrawerState> _innerDrawerKey =
        GlobalKey<InnerDrawerState>();

    double calculateDrawerOffset() {
      // Tested Virtual Devices Sizes
      // Pixel C portrait: 900 x 1224
      // Pixel 4 portrait: 392.72727272727275 x 781.0909090909091
      // Pixel 6 portrait: 360 x 752
      // 7.6" Foldable (closed) portrait: 294.6666666666667 x 688
      // 7.6" Foldable (open) portrait: 589.3333333333334 x 688
      // Galaxy Tab S8 portrait: 1066.6666666666667 x 1650.6666666666667
      // S22 Ultra 5G portrait: 480 x 981.3333333333334
      // OnePlus 7T portrait: 360 x 752

      final double width = MediaQuery.of(context).size.width;

      if (width >= 1600) return -0.65; // Tuned on Galaxy Tab S8
      if (width >= 1200) return -0.55; // Tuned on Pixel C
      if (width >= 1000) return -0.4; // Tuned on Galaxy Tab S8
      if (width >= 900) return -0.35; // Tuned on Pixel C
      if (width >= 700) return -0.3; // Tuned on Pixel 4
      if (width >= 600) return -0.25; // Tuned on 7.6" Foldable Open
      if (width >= 500) return -0.15; // Tuned on 7.6" Foldable Open
      if (width >= 400) return 0.25; // Tuned on S22 Ultra 5G
      if (width >= 300) return 0.6; // Tuned on Pixel 6
      if (width >= 200) return 0.7; // Tuned on 7.6" Foldable Closed
      return 0.4;
    }

    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: true,
      swipeChild: true,
      offset: IDOffset.horizontal(calculateDrawerOffset()),
      leftChild: _AppDrawer(innerDrawerKey: _innerDrawerKey),
      scaffold: Scaffold(
        appBar: AppBar(
          leading: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
            builder: (context, state) {
              return IconButton(
                icon: Badge(
                  animationDuration: Duration.zero,
                  badgeColor: Theme.of(context).colorScheme.secondary,
                  position: BadgePosition.topEnd(top: 1, end: -2),
                  showBadge: state is AnnouncementsSuccess && state.unread,
                  child: const Icon(Icons.menu),
                ),
                onPressed: () {
                  _innerDrawerKey.currentState?.open();
                },
              );
            },
          ),
          title: title,
          actions: actions,
        ),
        body: PageBody(
          child: DoubleBackToExit(
            innerDrawerKey: _innerDrawerKey,
            child: body,
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const _AppDrawer({
    Key? key,
    required this.innerDrawerKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    final double height = MediaQuery.of(context).size.height;

    return Drawer(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (height > 500) const _Logo(),
                  if (height <= 500)
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                  const _ServerSelector(),
                  const Gap(4),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ListTile(
                          //   tileColor: Colors.transparent,
                          //   leading: const FaIcon(
                          //     FontAwesomeIcons.tv,
                          //   ),
                          //   title: const Text('Activity'),
                          //   onTap: () {},
                          // ),
                          DrawerTile(
                            selected: route?.settings.name == '/users',
                            leading: const FaIcon(
                              FontAwesomeIcons.users,
                            ),
                            title: const Text(LocaleKeys.users_title).tr(),
                            onTap: () {
                              if (route?.settings.name != '/users') {
                                Navigator.of(context).pushReplacementNamed(
                                  '/users',
                                );
                              } else {
                                innerDrawerKey.currentState!.close();
                              }
                            },
                          ),
                          // ListTile(
                          //   tileColor: Colors.transparent,
                          //   leading: const FaIcon(
                          //     FontAwesomeIcons.chartBar,
                          //   ),
                          //   title: const Text('Graphs'),
                          //   onTap: () {},
                          // ),
                        ],
                      ),
                    ),
                  ),
                  _SettingsGroup(
                    innerDrawerKey: innerDrawerKey,
                    route: route,
                    useListTiles: height > 500,
                  ),
                  const Gap(4),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.001,
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Needed for space behind status bar
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          const Gap(8),
          // Logo section
          const FittedBox(
            child: Padding(
              padding: EdgeInsets.only(
                left: 8,
                right: 16,
              ),
              child: TautulliLogoTitle(),
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}

class _ServerSelector extends StatefulWidget {
  const _ServerSelector({Key? key}) : super(key: key);

  @override
  State<_ServerSelector> createState() => __ServerSelectorState();
}

class __ServerSelectorState extends State<_ServerSelector> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsSuccess && state.serverList.length > 1) {
          List<ServerModel> nonActiveServers = [...state.serverList];
          nonActiveServers.removeWhere(
            (server) =>
                server.tautulliId == state.appSettings.activeServer.tautulliId,
          );

          return ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                isOpen = !isOpen;
              });
            },
            expandedHeaderPadding: const EdgeInsets.all(0),
            elevation: 0,
            children: [
              ExpansionPanel(
                isExpanded: isOpen,
                canTapOnHeader: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                headerBuilder: (context, isExpanded) => ListTile(
                  tileColor: Colors.transparent,
                  leading: WebsafeSvg.asset(
                    'assets/logos/logo_flat.svg',
                    color: Theme.of(context).colorScheme.tertiary,
                    height: 30,
                  ),
                  title: Text(
                    state.appSettings.activeServer.plexName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: nonActiveServers.map(
                    (server) {
                      return ListTile(
                        tileColor: Theme.of(context).scaffoldBackgroundColor,
                        leading: const SizedBox(width: 30),
                        title: Text(
                          server.plexName,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          setState(() {
                            isOpen = !isOpen;
                          });
                          context.read<SettingsBloc>().add(
                                SettingsUpdateActiveServer(
                                  activeServer: server,
                                ),
                              );
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          );
        }

        return const SizedBox(height: 0, width: 0);
      },
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final ModalRoute<Object?>? route;
  final bool useListTiles;

  const _SettingsGroup({
    Key? key,
    required this.innerDrawerKey,
    required this.route,
    this.useListTiles = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (useListTiles) {
      return Column(
        children: [
          Divider(
            indent: 8,
            endIndent: 8,
            color: Theme.of(context).textTheme.subtitle2!.color,
          ),
          DrawerTile(
            selected: route?.settings.name == '/announcements',
            leading: const FaIcon(
              FontAwesomeIcons.bullhorn,
            ),
            title: const Text(LocaleKeys.announcements_title).tr(),
            trailing: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
              builder: (context, state) {
                if (state is AnnouncementsSuccess && state.unread) {
                  return FaIcon(
                    FontAwesomeIcons.solidCircle,
                    size: 12,
                    color: Theme.of(context).colorScheme.secondary,
                  );
                }

                return const SizedBox(height: 0, width: 0);
              },
            ),
            onTap: () {
              if (route?.settings.name != '/announcements') {
                Navigator.of(context).pushReplacementNamed(
                  '/announcements',
                );
              } else {
                innerDrawerKey.currentState!.close();
              }
            },
          ),
          DrawerTile(
            selected: route?.settings.name == '/donate',
            leading: const FaIcon(
              FontAwesomeIcons.solidHeart,
              color: Colors.red,
            ),
            title: const Text(LocaleKeys.donate_title).tr(),
            onTap: () {
              if (route?.settings.name != '/donate') {
                Navigator.of(context).pushReplacementNamed(
                  '/donate',
                );
              } else {
                innerDrawerKey.currentState!.close();
              }
            },
          ),
          DrawerTile(
            //TODO: Change default route once activity exists
            selected: route?.settings.name == '/settings' ||
                route?.settings.name == '/',
            leading: const FaIcon(
              FontAwesomeIcons.gears,
            ),
            title: const Text(LocaleKeys.settings_title).tr(),
            onTap: () {
              if (route?.settings.name != '/settings') {
                Navigator.of(context).pushReplacementNamed(
                  '/settings',
                );
              } else {
                innerDrawerKey.currentState!.close();
              }
            },
          ),
        ],
      );
    }

    return IntrinsicHeight(
      child: Column(
        children: [
          Divider(
            height: 0,
            indent: 8,
            endIndent: 8,
            color: Theme.of(context).textTheme.subtitle2!.color,
          ),
          const Gap(4),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
                  builder: (context, state) {
                    return Badge(
                      animationDuration: Duration.zero,
                      badgeColor: Theme.of(context).colorScheme.secondary,
                      position: BadgePosition.topEnd(top: 9, end: 7),
                      showBadge: state is AnnouncementsSuccess && state.unread,
                      child: DrawerIconButton(
                        selected: route?.settings.name == '/announcements',
                        icon: const FaIcon(
                          FontAwesomeIcons.bullhorn,
                        ),
                        onPressed: () {
                          if (route?.settings.name != '/announcements') {
                            Navigator.of(context)
                                .pushReplacementNamed('/announcements');
                          } else {
                            innerDrawerKey.currentState!.close();
                          }
                        },
                      ),
                    );
                  },
                ),
                DrawerIconButton(
                  selected: route?.settings.name == '/donate',
                  icon: const FaIcon(
                    FontAwesomeIcons.solidHeart,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    if (route?.settings.name != '/donate') {
                      Navigator.of(context).pushReplacementNamed('/donate');
                    } else {
                      innerDrawerKey.currentState!.close();
                    }
                  },
                ),
                DrawerIconButton(
                  //TODO: Change default route once activity exists
                  selected: route?.settings.name == '/settings' ||
                      route?.settings.name == '/',
                  icon: const FaIcon(
                    FontAwesomeIcons.gears,
                  ),
                  onPressed: () {
                    if (route?.settings.name != '/settings') {
                      Navigator.of(context).pushReplacementNamed('/settings');
                    } else {
                      innerDrawerKey.currentState!.close();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
