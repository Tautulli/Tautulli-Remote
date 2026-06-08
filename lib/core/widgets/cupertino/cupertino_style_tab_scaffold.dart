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
import '../notifying_icon.dart';
import 'dialogs/cupertino_style_rate_app_dialog.dart';

class CupertinoStyleTabScaffold extends StatefulWidget {
  const CupertinoStyleTabScaffold({super.key});

  @override
  State<CupertinoStyleTabScaffold> createState() => _CupertinoStyleTabScaffoldState();
}

class _CupertinoStyleTabScaffoldState extends State<CupertinoStyleTabScaffold> {
  @override
  void initState() {
    super.initState();
    cupertinoTabController.index = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final route = cupertinoInitialRoute.value;
      cupertinoInitialRoute.value = null;

      if (route == '/wizard') {
        await showCupertinoSheet(
          context: context,
          useNestedNavigation: true,
          enableDrag: false,
          scrollableBuilder: (context, scrollController) => const CupertinoStyleWizardPage(),
        );
      } else if (route == '/changelog') {
        await navigatorKey.currentState?.push(
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => const CupertinoStyleChangelogPage(),
          ),
        );
      }

      if (rateApp.shouldOpenDialog) {
        showCupertinoDialog(
          context: context,
          builder: (context) => const CupertinoStyleRateAppDialog(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: cupertinoTabController,
      tabBar: CupertinoTabBar(
        iconSize: 20,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              CupertinoIcons.tv,
              size: 24,
            ),
            label: LocaleKeys.activity_title.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              CupertinoIcons.gobackward,
              size: 24,
            ),
            label: LocaleKeys.history_title.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              CupertinoIcons.clock,
              size: 24,
            ),
            label: LocaleKeys.recently_added_title.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              CupertinoIcons.film,
              size: 24,
            ),
            label: LocaleKeys.libraries_title.tr(),
          ),
          BottomNavigationBarItem(
            icon: const _MoreTabIcon(),
            label: LocaleKeys.more_title.tr(),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        if (index == 4) {
          return CupertinoTabView(
            routes: cupertinoRoutes,
            navigatorKey: moreTabNavigatorKey,
            builder: (context) => const CupertinoStyleMorePage(),
          );
        }

        return CupertinoTabView(
          routes: cupertinoRoutes,
          builder: (context) {
            switch (index) {
              case 1:
                return const CupertinoStyleHistoryPage(showBackButton: false);
              case 2:
                return const CupertinoStyleRecentlyAddedPage(showBackButton: false);
              case 3:
                return const CupertinoStyleLibrariesPage(showBackButton: false);
              case 0:
              default:
                return const CupertinoStyleActivityPage(showBackButton: false);
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
