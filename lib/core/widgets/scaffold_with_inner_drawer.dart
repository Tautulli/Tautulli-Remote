import 'package:badges/badges.dart' as badges;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'tautulli_logo_title.dart';

class ScaffoldWithInnerDrawer extends StatelessWidget {
  final Widget title;
  final Widget body;
  final List<Widget>? actions;

  const ScaffoldWithInnerDrawer({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<InnerDrawerState> innerDrawerKey = GlobalKey<InnerDrawerState>();

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
      key: innerDrawerKey,
      onTapClose: true,
      swipeChild: true,
      offset: IDOffset.horizontal(calculateDrawerOffset()),
      leftChild: Stack(
        children: [
          // Since the NavigationDrawer BorderRadius cannot be overwritten use stack to create a solid background to
          // to hide these corners
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Positioned.fill(
            child: _AppDrawer(innerDrawerKey: innerDrawerKey),
          ),
        ],
      ),
      scaffold: Scaffold(
        appBar: AppBar(
          leading: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
            builder: (context, state) {
              return IconButton(
                icon: badges.Badge(
                  badgeAnimation: const badges.BadgeAnimation.fade(
                    animationDuration: Duration(milliseconds: 400),
                  ),
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: Theme.of(context).colorScheme.secondary,
                  ),
                  position: badges.BadgePosition.topEnd(top: 1, end: -2),
                  showBadge: state is AnnouncementsSuccess && state.unread,
                  child: const Icon(Icons.menu),
                ),
                onPressed: () {
                  innerDrawerKey.currentState?.open();
                },
              );
            },
          ),
          title: title,
          actions: actions,
        ),
        body: SafeArea(
          child: DoubleBackToExit(
            innerDrawerKey: innerDrawerKey,
            child: body,
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends StatefulWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const _AppDrawer({
    required this.innerDrawerKey,
  });

  @override
  State<_AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<_AppDrawer> {
  int screenIndex = -1;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      if (route?.settings.name == '/activity' || route?.settings.name == '/') {
        setState(() {
          screenIndex = 0;
        });
      } else if (route?.settings.name == '/history') {
        setState(() {
          screenIndex = 1;
        });
      } else if (route?.settings.name == '/recent') {
        setState(() {
          screenIndex = 2;
        });
      } else if (route?.settings.name == '/libraries') {
        setState(() {
          screenIndex = 3;
        });
      } else if (route?.settings.name == '/users') {
        setState(() {
          screenIndex = 4;
        });
      } else if (route?.settings.name == '/statistics') {
        setState(() {
          screenIndex = 5;
        });
      } else if (route?.settings.name == '/graphs') {
        setState(() {
          screenIndex = 6;
        });
      } else if (route?.settings.name == '/announcements') {
        setState(() {
          screenIndex = 7;
        });
      } else if (route?.settings.name == '/donate') {
        setState(() {
          screenIndex = 8;
        });
      } else if (route?.settings.name == '/settings') {
        setState(() {
          screenIndex = 9;
        });
      }
    });
  }

  void handleScreenChanged(int selectedScreen) {
    if (selectedScreen != screenIndex) {
      if (selectedScreen == 0) {
        Navigator.of(context).pushReplacementNamed(
          '/activity',
        );
      } else if (selectedScreen == 1) {
        Navigator.of(context).pushReplacementNamed(
          '/history',
        );
      } else if (selectedScreen == 2) {
        Navigator.of(context).pushReplacementNamed(
          '/recent',
        );
      } else if (selectedScreen == 3) {
        Navigator.of(context).pushReplacementNamed(
          '/libraries',
        );
      } else if (selectedScreen == 4) {
        Navigator.of(context).pushReplacementNamed(
          '/users',
        );
      } else if (selectedScreen == 5) {
        Navigator.of(context).pushReplacementNamed(
          '/statistics',
        );
      } else if (selectedScreen == 6) {
        Navigator.of(context).pushReplacementNamed(
          '/graphs',
        );
      } else if (selectedScreen == 7) {
        Navigator.of(context).pushReplacementNamed(
          '/announcements',
        );
      } else if (selectedScreen == 8) {
        Navigator.of(context).pushReplacementNamed(
          '/donate',
        );
      } else if (selectedScreen == 9) {
        Navigator.of(context).pushReplacementNamed(
          '/settings',
        );
      }
    } else {
      widget.innerDrawerKey.currentState!.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: NavigationDrawer(
        onDestinationSelected: handleScreenChanged,
        selectedIndex: screenIndex,
        children: [
          Container(
            height: MediaQuery.of(context).viewPadding.top,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          if (height > 500) const _Logo(),
          const _ServerSelector(),
          const Gap(4),
          NavigationDrawerDestination(
            icon: const SizedBox(
              width: 25,
              child: FaIcon(
                FontAwesomeIcons.tv,
                size: 20,
              ),
            ),
            label: const Text(LocaleKeys.activity_title).tr(),
          ),
          NavigationDrawerDestination(
            icon: const SizedBox(
              width: 25,
              child: FaIcon(
                FontAwesomeIcons.clockRotateLeft,
              ),
            ),
            label: const Text(LocaleKeys.history_title).tr(),
          ),
          NavigationDrawerDestination(
            icon: const SizedBox(
              width: 25,
              child: FaIcon(
                FontAwesomeIcons.clock,
              ),
            ),
            label: const Text(LocaleKeys.recently_added_title).tr(),
          ),
          NavigationDrawerDestination(
            icon: const SizedBox(
              width: 25,
              child: FaIcon(
                FontAwesomeIcons.photoFilm,
                size: 20,
              ),
            ),
            label: const Text(LocaleKeys.libraries_title).tr(),
          ),
          NavigationDrawerDestination(
            icon: const SizedBox(
              width: 25,
              child: FaIcon(
                FontAwesomeIcons.users,
                size: 20,
              ),
            ),
            label: const Text(LocaleKeys.users_title).tr(),
          ),
          NavigationDrawerDestination(
            icon: const SizedBox(
              width: 25,
              child: FaIcon(
                FontAwesomeIcons.listOl,
              ),
            ),
            label: const Text(LocaleKeys.statistics_title).tr(),
          ),
          NavigationDrawerDestination(
            icon: const SizedBox(
              width: 25,
              child: FaIcon(
                FontAwesomeIcons.chartColumn,
              ),
            ),
            label: const Text(LocaleKeys.graphs_title).tr(),
          ),
          Divider(
            indent: 8,
            endIndent: 8,
            color: Theme.of(context).textTheme.titleSmall!.color,
          ),
          NavigationDrawerDestination(
            icon: const SizedBox(
              width: 25,
              child: FaIcon(
                FontAwesomeIcons.bullhorn,
              ),
            ),
            label: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(LocaleKeys.announcements_title).tr(),
                  BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
                    builder: (context, state) {
                      if (state is AnnouncementsSuccess && state.unread) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: FaIcon(
                            FontAwesomeIcons.solidCircle,
                            size: 12,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
          NavigationDrawerDestination(
            icon: const SizedBox(
              width: 25,
              child: FaIcon(
                FontAwesomeIcons.solidHeart,
                color: Colors.red,
              ),
            ),
            label: const Text(LocaleKeys.donate_title).tr(),
          ),
          NavigationDrawerDestination(
            icon: const SizedBox(
              width: 25,
              child: FaIcon(
                FontAwesomeIcons.gears,
                size: 21,
              ),
            ),
            label: const Text(LocaleKeys.settings_title).tr(),
          ),
          const Gap(4),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

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
  const _ServerSelector();

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
            (server) => server.tautulliId == state.appSettings.activeServer.tautulliId,
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
