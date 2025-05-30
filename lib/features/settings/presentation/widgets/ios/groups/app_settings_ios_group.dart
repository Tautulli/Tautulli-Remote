import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';
import '../../../pages/ios/accessibility_ios_page.dart';
import '../../../pages/ios/advanced_ios_page.dart';
import '../../../pages/ios/theme_ios_page.dart';
import '../action_sheets/activity_refresh_rate_action_sheet.dart';
import '../action_sheets/server_timeout_action_sheet.dart';

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

            return CupertinoListTile.notched(
              leading: const FaIcon(FontAwesomeIcons.stopwatch),
              trailing: const CupertinoListTileChevron(),
              title: const Text(LocaleKeys.server_timeout_title).tr(),
              subtitle: Text(_serverTimeoutDisplay(serverTimeout)),
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => ServerTimeoutActionSheet(initialValue: serverTimeout),
              ),
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final refreshRate = state.appSettings.refreshRate;

            return CupertinoListTile.notched(
              leading: const FaIcon(FontAwesomeIcons.solidClock),
              trailing: const CupertinoListTileChevron(),
              title: const Text(LocaleKeys.activity_refresh_rate_title).tr(),
              subtitle: Text(_activityRefreshRateDisplay(refreshRate)),
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => ActivityRefreshRateActionSheet(initialValue: refreshRate),
              ),
            );
          },
        ),
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.wrench),
          trailing: const CupertinoListTileChevron(),
          title: const Text(LocaleKeys.advanced_title).tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => const AdvancedIosPage(),
            ),
          ),
        ),
        //TODO: Remove for cupertino framework
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.palette),
          trailing: const CupertinoListTileChevron(),
          title: const Text(LocaleKeys.themes_title).tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => const ThemeIosPage(),
            ),
          ),
        ),
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.universalAccess),
          trailing: const CupertinoListTileChevron(),
          title: const Text(LocaleKeys.accessibility_title).tr(),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => const AccessibilityIosPage(),
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
