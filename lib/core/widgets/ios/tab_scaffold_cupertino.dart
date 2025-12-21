import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../features/activity/presentation/pages/ios/activity_ios_page.dart';
import '../../../features/history/presentation/pages/ios/history_ios_page.dart';
import '../../../features/settings/presentation/pages/ios/settings_ios_page.dart';
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
              CupertinoIcons.gear_alt_fill,
              size: 24,
            ),
            label: LocaleKeys.settings_title.tr(),
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
                return HistoryIosPage();
              case 2:
                return SettingsIosPage();
              case 0:
              default:
                return ActivityIosPage();
            }
          },
        );
      },
    );
  }
}
