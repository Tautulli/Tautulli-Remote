import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../features/activity/presentation/pages/ios/activity_ios_page.dart';
import '../../../features/history/presentation/pages/ios/history_ios_page.dart';
import '../../../features/libraries/presentation/pages/ios/libraries_ios_page.dart';
import '../../../features/more/presentation/pages/more_ios_page.dart';
import '../../../features/recently_added/presentation/pages/ios/recently_added_ios_page.dart';
import '../../../translations/locale_keys.g.dart';
import '../../global_keys/global_keys.dart';

class TabScaffoldCupertino extends StatefulWidget {
  const TabScaffoldCupertino({super.key});

  @override
  State<TabScaffoldCupertino> createState() => _TabScaffoldCupertinoState();
}

class _TabScaffoldCupertinoState extends State<TabScaffoldCupertino> {
  @override
  void initState() {
    super.initState();
    cupertinoTabController.index = 0;
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
            icon: const Icon(
              CupertinoIcons.ellipsis,
              size: 24,
            ),
            label: LocaleKeys.more_title.tr(),
          ),
        ],
        onTap: (index) {
          // print('Tapped tab $index');
        },
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 1:
                return const HistoryIosPage(showBackButton: false);
              case 2:
                return const RecentlyAddedIosPage(showBackButton: false);
              case 3:
                return const LibrariesIosPage(showBackButton: false);
              case 4:
                return const MoreIosPage();
              case 0:
              default:
                return const ActivityIosPage(showBackButton: false);
            }
          },
        );
      },
    );
  }
}
