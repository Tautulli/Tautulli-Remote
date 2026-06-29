import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';
import '../../../pages/cupertino/cupertino_style_advanced_page.dart';
import '../../../pages/cupertino/cupertino_style_accessibility_page.dart';
import '../../../pages/cupertino/cupertino_style_appearance_page.dart';
import '../bottom_sheets/cupertino_style_activity_refresh_rate_bottom_sheet.dart';
import '../bottom_sheets/cupertino_style_server_timeout_bottom_sheet.dart';

class CupertinoStyleAppSettingsGroup extends StatelessWidget {
  const CupertinoStyleAppSettingsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStyleListSection(
      headerText: LocaleKeys.settings_and_operations_title.tr(),
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final serverTimeout = state.appSettings.serverTimeout;

            return CupertinoStyleNotchedCupertinoListTile(
              leading: const Icon(
                CupertinoIcons.stopwatch_fill,
                color: ThemeHelper.cupertinoListTileIconColor,
              ),
              titleText: LocaleKeys.server_timeout_title.tr(),
              subtitleText: _serverTimeoutDisplay(serverTimeout),
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoStyleServerTimeoutBottomSheet(
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

            return CupertinoStyleNotchedCupertinoListTile(
              leading: const Icon(
                CupertinoIcons.clock_fill,
                color: ThemeHelper.cupertinoListTileIconColor,
              ),
              titleText: LocaleKeys.activity_refresh_rate_title.tr(),
              subtitleText: _activityRefreshRateDisplay(refreshRate),
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoStyleActivityRefreshRateBottomSheet(
                  initialValue: refreshRate,
                ),
              ),
            );
          },
        ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: const Icon(
            CupertinoIcons.wrench_fill,
            color: ThemeHelper.cupertinoListTileIconColor,
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.advanced_title.tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => CupertinoStyleAdvancedPage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: const Icon(
            CupertinoIcons.paintbrush_fill,
            color: ThemeHelper.cupertinoListTileIconColor,
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.appearance_title.tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => CupertinoStyleAppearancePage(
                previousPageTitle: LocaleKeys.settings_title.tr(),
              ),
            ),
          ),
        ),
        CupertinoStyleNotchedCupertinoListTile(
          leading: const FaIcon(
            FontAwesomeIcons.universalAccess,
            color: ThemeHelper.cupertinoListTileIconColor,
            size: 23,
          ),
          trailing: const CupertinoListTileChevron(),
          titleText: LocaleKeys.accessibility_title.tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => CupertinoStyleAccessibilityPage(
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
