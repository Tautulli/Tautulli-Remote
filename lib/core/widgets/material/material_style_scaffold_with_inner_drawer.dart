import 'package:badges/badges.dart' as badges;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../dependency_injection.dart' as di;
import '../../../features/announcements/presentation/bloc/announcements_bloc.dart';
import '../../../features/settings/domain/usecases/settings.dart';
import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../translations/locale_keys.g.dart';
import '../../database/data/models/server_model.dart';
import '../../helpers/theme_helper.dart';
import '../base/double_back_to_exit.dart';
import '../base/tautulli_logo_title.dart';

class MaterialStyleScaffoldWithInnerDrawer extends StatefulWidget {
  final Widget title;
  final Widget body;
  final List<Widget>? actions;

  const MaterialStyleScaffoldWithInnerDrawer({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  State<MaterialStyleScaffoldWithInnerDrawer> createState() => _MaterialStyleScaffoldWithInnerDrawerState();
}

class _MaterialStyleScaffoldWithInnerDrawerState extends State<MaterialStyleScaffoldWithInnerDrawer> {
  final GlobalKey<InnerDrawerState> innerDrawerKey = GlobalKey<InnerDrawerState>();

  @override
  Widget build(BuildContext context) {
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
      ),
      child: InnerDrawer(
        key: innerDrawerKey,
        onTapClose: true,
        swipeChild: true,
        offset: IDOffset.horizontal(calculateDrawerOffset()),
        backgroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeHelper.darkenedColor(
                Theme.of(context).colorScheme.surface,
              ),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        leftChild: _AppDrawer(innerDrawerKey: innerDrawerKey),
        scaffold: Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            centerTitle: defaultTargetPlatform == TargetPlatform.iOS,
            leading: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
              builder: (context, announcementsState) {
                return BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, settingsState) {
                    settingsState as SettingsSuccess;

                    return IconButton(
                      icon: badges.Badge(
                        badgeAnimation: const badges.BadgeAnimation.fade(
                          animationDuration: Duration(milliseconds: 400),
                        ),
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Theme.of(context).colorScheme.primary,
                        ),
                        position: badges.BadgePosition.topEnd(top: 1, end: -2),
                        showBadge:
                            (announcementsState is AnnouncementsSuccess && announcementsState.unread) ||
                            settingsState.appSettings.appUpdateAvailable,
                        child: const Icon(Icons.menu),
                      ),
                      onPressed: () {
                        innerDrawerKey.currentState?.open();
                      },
                    );
                  },
                );
              },
            ),
            title: widget.title,
            actions: widget.actions,
          ),
          body: SafeArea(
            child: DoubleBackToExit(
              innerDrawerKey: innerDrawerKey,
              child: widget.body,
            ),
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
  static const List<String> _routes = [
    '/activity',
    '/history',
    '/recent',
    '/libraries',
    '/users',
    '/statistics',
    '/graphs',
    '/announcements',
    '/donate',
    '/settings',
  ];

  static const Map<String, int> _routeIndex = {
    '/activity': 0,
    '/history': 1,
    '/recent': 2,
    '/libraries': 3,
    '/users': 4,
    '/statistics': 5,
    '/graphs': 6,
    '/announcements': 7,
    '/donate': 8,
    '/settings': 9,
  };

  int screenIndex = -1;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final routeName = ModalRoute.of(context)?.settings.name;
      final effectiveRoute = routeName == '/' ? '/${di.sl<Settings>().getHomePage()}' : routeName ?? '';
      setState(() {
        screenIndex = _routeIndex[effectiveRoute] ?? 0;
      });
    });
  }

  void handleScreenChanged(int selectedScreen) {
    if (selectedScreen != screenIndex) {
      Navigator.of(context).pushReplacementNamed(_routes[selectedScreen]);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).viewPadding.top,
            color: ThemeHelper.darkenedColor(
              Theme.of(context).colorScheme.surface,
            ),
          ),
          if (height > 500) const _Logo(),
          const _ServerSelector(),
          Expanded(
            child: DrawerTheme(
              data: const DrawerThemeData(shape: RoundedRectangleBorder()),
              child: NavigationDrawer(
                indicatorColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                elevation: 0,
                onDestinationSelected: handleScreenChanged,
                selectedIndex: screenIndex,
                children: [
                  const Gap(4),
                  NavigationDrawerDestination(
                    icon: SizedBox(
                      width: 25,
                      child: FaIcon(
                        FontAwesomeIcons.tv,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    label: Text(
                      LocaleKeys.activity_title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ).tr(),
                  ),
                  NavigationDrawerDestination(
                    icon: SizedBox(
                      width: 25,
                      child: FaIcon(
                        FontAwesomeIcons.clockRotateLeft,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    label: Text(
                      LocaleKeys.history_title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ).tr(),
                  ),
                  NavigationDrawerDestination(
                    icon: SizedBox(
                      width: 25,
                      child: FaIcon(
                        FontAwesomeIcons.clock,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    label: Text(
                      LocaleKeys.recently_added_title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ).tr(),
                  ),
                  NavigationDrawerDestination(
                    icon: SizedBox(
                      width: 25,
                      child: FaIcon(
                        FontAwesomeIcons.photoFilm,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                    label: Text(
                      LocaleKeys.libraries_title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ).tr(),
                  ),
                  NavigationDrawerDestination(
                    icon: SizedBox(
                      width: 25,
                      child: FaIcon(
                        FontAwesomeIcons.users,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                    label: Text(
                      LocaleKeys.users_title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ).tr(),
                  ),
                  NavigationDrawerDestination(
                    icon: SizedBox(
                      width: 25,
                      child: FaIcon(
                        FontAwesomeIcons.listOl,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    label: Text(
                      LocaleKeys.statistics_title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ).tr(),
                  ),
                  NavigationDrawerDestination(
                    icon: SizedBox(
                      width: 25,
                      child: FaIcon(
                        FontAwesomeIcons.chartColumn,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    label: Text(
                      LocaleKeys.graphs_title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ).tr(),
                  ),
                  const Divider(
                    indent: 8,
                    endIndent: 8,
                  ),
                  NavigationDrawerDestination(
                    icon: SizedBox(
                      width: 25,
                      child: FaIcon(
                        FontAwesomeIcons.bullhorn,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    label: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.announcements_title,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ).tr(),
                          BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
                            builder: (context, state) {
                              if (state is AnnouncementsSuccess && state.unread) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: FaIcon(
                                    FontAwesomeIcons.solidCircle,
                                    size: 12,
                                    color: Theme.of(context).colorScheme.primary,
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
                    label: Text(
                      LocaleKeys.donate_title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ).tr(),
                  ),
                  NavigationDrawerDestination(
                    icon: SizedBox(
                      width: 25,
                      child: FaIcon(
                        FontAwesomeIcons.gears,
                        size: 21,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    label: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.settings_title,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ).tr(),
                          BlocBuilder<SettingsBloc, SettingsState>(
                            builder: (context, state) {
                              if (state is SettingsSuccess && state.appSettings.appUpdateAvailable) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: FaIcon(
                                    FontAwesomeIcons.solidCircle,
                                    size: 12,
                                    color: Theme.of(context).colorScheme.primary,
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
                  const Gap(4),
                ],
              ),
            ),
          ),
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
        color: ThemeHelper.darkenedColor(
          Theme.of(context).colorScheme.surface,
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(8),
          FittedBox(
            child: Padding(
              padding: EdgeInsets.only(
                left: 8,
                right: 16,
              ),
              child: TautulliLogoTitle(),
            ),
          ),
          Gap(16),
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

class __ServerSelectorState extends State<_ServerSelector> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsSuccess && state.serverList.length > 1) {
          List<ServerModel> nonActiveServers = [...state.serverList];
          nonActiveServers.removeWhere(
            (server) => server.tautulliId == state.appSettings.activeServer.tautulliId,
          );

          return Material(
            color: ThemeHelper.darkenedColor(Theme.of(context).colorScheme.surface),
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: WebsafeSvg.asset(
                    'assets/logos/logo_flat.svg',
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                    height: 30,
                  ),
                  title: Text(
                    state.appSettings.activeServer.plexName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  trailing: AnimatedRotation(
                    turns: isOpen ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  onTap: () {
                    setState(() => isOpen = !isOpen);
                    if (isOpen) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  },
                ),
                SizeTransition(
                  sizeFactor: _animation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: nonActiveServers
                        .map(
                          (server) => ListTile(
                            leading: const SizedBox(width: 30),
                            title: Text(
                              server.plexName,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              setState(() => isOpen = false);
                              _controller.reverse();
                              context.read<SettingsBloc>().add(
                                SettingsUpdateActiveServer(activeServer: server),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
