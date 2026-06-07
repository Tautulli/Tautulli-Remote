import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';
import '../../../pages/ios/accessibility_ios_page.dart';
import '../../../pages/ios/advanced_ios_page.dart';
import '../../../pages/ios/appearance_ios_page.dart';
import '../bottom_sheets/activity_refresh_rate_ios_bottom_sheet.dart';
import '../bottom_sheets/server_timeout_ios_bottom_sheet.dart';

class AppSettingsIosGroup extends StatelessWidget {
  const AppSettingsIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.settings_and_operations_title.tr(),
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final serverTimeout = state.appSettings.serverTimeout;

            return CustomNotchedCupertinoListTile(
              leading: Icon(
                CupertinoIcons.stopwatch_fill,
                color: ThemeHelper.cupertinoListTileIconColor(),
              ),
              trailing: const CupertinoListTileChevron(),
              titleText: LocaleKeys.server_timeout_title.tr(),
              subtitleText: _serverTimeoutDisplay(serverTimeout),
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => ServerTimeoutIosBottomSheet(
                  initialValue: serverTimeout,
                ),
              ),
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final refreshRate = state.appSettings.refreshRate;

            return CustomNotchedCupertinoListTile(
              leading: Icon(
                CupertinoIcons.clock_fill,
                color: ThemeHelper.cupertinoListTileIconColor(),
              ),
              trailing: const CupertinoListTileChevron(),
              titleText: LocaleKeys.activity_refresh_rate_title.tr(),
              subtitleText: _activityRefreshRateDisplay(refreshRate),
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => ActivityRefreshRateIosBottomSheet(
                  initialValue: refreshRate,
                ),
              ),
            );
          },
        ),
        CustomNotchedCupertinoListTile(
          leading: Icon(
            CupertinoIcons.wrench_fill,
            color: ThemeHelper.cupertinoListTileIconColor(),
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.advanced_title.tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => AdvancedIosPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
        CustomNotchedCupertinoListTile(
          leading: Icon(
            CupertinoIcons.paintbrush_fill,
            color: ThemeHelper.cupertinoListTileIconColor(),
          ),
          trailing: const CupertinoListTileChevron(),
          //TODO:  Create translation key
          titleText: 'Appearance',
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => AppearanceIosPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
        CustomNotchedCupertinoListTile(
          leading: FaIcon(
            FontAwesomeIcons.universalAccess,
            color: ThemeHelper.cupertinoListTileIconColor(),
            size: 23,
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.accessibility_title.tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => AccessibilityIosPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _serverTimeoutDisplay(int timeout) {
    switch (timeout) {
      case (3):
        return '3 ${LocaleKeys.sec.tr()}';
      case (5):
        return '5 ${LocaleKeys.sec.tr()}';
      case (8):
        return '8 ${LocaleKeys.sec.tr()}';
      case (30):
        return '30 ${LocaleKeys.sec.tr()}';
      default:
        return '15 ${LocaleKeys.sec.tr()} (${LocaleKeys.default_title.tr()})';
    }
  }

  String _activityRefreshRateDisplay(int refreshRate) {
    switch (refreshRate) {
      case (5):
        return '5 ${LocaleKeys.sec.tr()} - ${LocaleKeys.faster_title.tr()}';
      case (7):
        return '7 ${LocaleKeys.sec.tr()} - ${LocaleKeys.fast_title.tr()}';
      case (10):
        return '10 ${LocaleKeys.sec.tr()} - ${LocaleKeys.normal_title.tr()}';
      case (15):
        return '15 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slow_title.tr()}';
      case (20):
        return '20 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slower_title.tr()}';
      default:
        return LocaleKeys.disabled_title.tr();
    }
  }
}
