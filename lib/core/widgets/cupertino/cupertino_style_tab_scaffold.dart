import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_framework.dart';
import '../../../features/activity/presentation/pages/cupertino/cupertino_style_activity_page.dart';
import '../../../features/announcements/presentation/bloc/announcements_bloc.dart';
import '../../../features/changelog/presentation/pages/cupertino/cupertino_style_changelog_page.dart';
import '../../../features/history/presentation/pages/cupertino/cupertino_style_history_page.dart';
import '../../../features/libraries/presentation/pages/cupertino/cupertino_style_libraries_page.dart';
import '../../../features/more/presentation/pages/cupertino/cupertino_style_more_page.dart';
import '../../../features/recently_added/presentation/pages/cupertino/cupertino_style_recently_added_page.dart';
import '../../../features/wizard/presentation/pages/cupertino/cupertino_style_wizard_page.dart';
import '../../../translations/locale_keys.g.dart';
import '../../global_keys/global_keys.dart';
import '../../rate_app/rate_app.dart';
import '../base/double_back_to_exit.dart';
import '../base/notifying_icon.dart';
import 'dialogs/cupertino_style_rate_app_dialog.dart';

const double _tabBarHeight = 55;
const double _iconTopPadding = 5;
const double _tabLabelFontSize = 10;
const double _tabLabelMinFontSize = 7;

class CupertinoStyleTabScaffold extends StatefulWidget {
  const CupertinoStyleTabScaffold({super.key});

  @override
  State<CupertinoStyleTabScaffold> createState() => _CupertinoStyleTabScaffoldState();
}

class _CupertinoStyleTabScaffoldState extends State<CupertinoStyleTabScaffold> {
  late final AutoSizeGroup _tabLabelGroup;

  @override
  void initState() {
    super.initState();
    _tabLabelGroup = AutoSizeGroup();
    cupertinoTabController.index = 0;
    cupertinoTabController.addListener(_onTabChanged);

    // CupertinoStyleTabScaffold is only inserted into the tree after SettingsSuccess
    // (gated by CupertinoApp.builder's BlocBuilder), so settings are guaranteed loaded
    // here — no need to wait for a BlocListener transition.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final route = appInitialRoute.value;
      appInitialRoute.value = null;

      if (route == CupertinoStyleWizardPage.routeName) {
        await showCupertinoSheet(
          context: context,
          useNestedNavigation: true,
          enableDrag: false,
          scrollableBuilder: (context, scrollController) => const CupertinoStyleWizardPage(),
        );
      } else if (route == CupertinoStyleChangelogPage.routeName) {
        await navigatorKey.currentState?.push(
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => const CupertinoStyleChangelogPage(),
          ),
        );
      }

      if (!mounted) return;

      if (!await initRateApp()) return;
      if (rateApp.shouldOpenDialog) {
        showCupertinoDialog(
          context: context,
          builder: (context) => const CupertinoStyleRateAppDialog(),
        );
      }
    });
  }

  @override
  void dispose() {
    cupertinoTabController.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() => setState(() {});

  Widget _buildTabLabel(BuildContext context, String text, int tabIndex) {
    return AutoSizeText(
      text,
      group: _tabLabelGroup,
      style: TextStyle(
        fontSize: _tabLabelFontSize,
        color: cupertinoTabController.index == tabIndex
            ? CupertinoTheme.of(context).primaryColor
            : CupertinoColors.inactiveGray,
      ),
      minFontSize: _tabLabelMinFontSize,
      maxLines: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Subscribe to locale changes so the tab bar labels below re-run their
    // `.tr()` calls when the language is switched at runtime. The tab scaffold
    // is the const `home` of CupertinoApp and reads nothing else that changes on
    // a locale switch, so without this dependency its build never re-runs and the
    // labels stay stale. Deliberately not a ValueKey on CupertinoTabScaffold —
    // that would recreate the inner tab navigators and reset their stacks; we
    // only need this build to re-run, which the dependency does in place.
    context.locale;

    return CupertinoTabScaffold(
      controller: cupertinoTabController,
      tabBar: CupertinoTabBar(
        height: _tabBarHeight,
        iconSize: 20,
        items: [
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: _iconTopPadding),
                  child: Icon(CupertinoIcons.tv, size: 24),
                ),
                _buildTabLabel(context, LocaleKeys.activity_title.tr(), 0),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: _iconTopPadding),
                  child: Icon(CupertinoIcons.gobackward, size: 24),
                ),
                _buildTabLabel(context, LocaleKeys.history_title.tr(), 1),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: _iconTopPadding),
                  child: Icon(CupertinoIcons.clock, size: 24),
                ),
                _buildTabLabel(context, LocaleKeys.recently_added_title.tr(), 2),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: _iconTopPadding),
                  child: Icon(CupertinoIcons.film, size: 24),
                ),
                _buildTabLabel(context, LocaleKeys.libraries_title.tr(), 3),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: _iconTopPadding),
                  child: _MoreTabIcon(),
                ),
                _buildTabLabel(context, LocaleKeys.more_title.tr(), 4),
              ],
            ),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        if (index == 4) {
          return CupertinoTabView(
            routes: cupertinoRoutes,
            navigatorKey: moreTabNavigatorKey,
            builder: (context) => const DoubleBackToExit(
              child: CupertinoStyleMorePage(),
            ),
          );
        }

        return CupertinoTabView(
          routes: cupertinoRoutes,
          builder: (context) {
            switch (index) {
              case 1:
                return const DoubleBackToExit(
                  child: CupertinoStyleHistoryPage(showBackButton: false),
                );
              case 2:
                return const DoubleBackToExit(
                  child: CupertinoStyleRecentlyAddedPage(showBackButton: false),
                );
              case 3:
                return const DoubleBackToExit(
                  child: CupertinoStyleLibrariesPage(showBackButton: false),
                );
              case 0:
              default:
                return const DoubleBackToExit(
                  child: CupertinoStyleActivityPage(showBackButton: false),
                );
            }
          },
        );
      },
    );
  }
}

//* Allows the icon for the more tab to only be rebuilt when the icon needs to be turned on (navigating away from more tab) or off (navigating to more tab)
class _MoreTabIcon extends StatefulWidget {
  const _MoreTabIcon();

  @override
  State<_MoreTabIcon> createState() => _MoreTabIconState();
}

class _MoreTabIconState extends State<_MoreTabIcon> {
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = cupertinoTabController.index;
    cupertinoTabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    cupertinoTabController.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    final currentIndex = cupertinoTabController.index;
    if (_previousIndex == 4 || currentIndex == 4) {
      setState(() {});
    }
    _previousIndex = currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
      builder: (context, state) {
        return ((state is AnnouncementsSuccess && state.unread) && cupertinoTabController.index != 4)
            ? NotifyingIcon(
                icon: CupertinoIcons.ellipsis,
                baseColor: CupertinoColors.inactiveGray,
                notifyingColor: CupertinoTheme.of(context).primaryColor,
                size: 24,
              )
            : const Icon(
                CupertinoIcons.ellipsis,
                size: 24,
              );
      },
    );
  }
}
