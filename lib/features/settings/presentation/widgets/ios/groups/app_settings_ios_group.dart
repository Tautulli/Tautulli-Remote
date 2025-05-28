import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tautulli_remote/core/helpers/color_palette_helper.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class AppSettingsIosGroup extends StatelessWidget {
  const AppSettingsIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: const Text(
        LocaleKeys.settings_and_operations_title,
        style: TextStyle(
          color: TautulliColorPalette.amber,
        ),
      ).tr(),
      backgroundColor: CupertinoColors.transparent,
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final serverTimeout = state.appSettings.serverTimeout;

            return CupertinoListTile.notched(
              leading: FaIcon(
                FontAwesomeIcons.stopwatch,
                color: TautulliColorPalette.notWhite,
              ),
              // trailing: CupertinoListTileChevron(),
              title: Text(LocaleKeys.server_timeout_title).tr(),
              subtitle: Text(_serverTimeoutDisplay(serverTimeout)),
              // onTap: () async => await showDialog(
              //   context: context,
              //   builder: (context) => ServerTimeoutDialog(
              //     initialValue: serverTimeout,
              //   ),
              // ),
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final refreshRate = state.appSettings.refreshRate;

            return CupertinoListTile.notched(
              leading: FaIcon(
                FontAwesomeIcons.solidClock,
                color: TautulliColorPalette.notWhite,
              ),
              // trailing: CupertinoListTileChevron(),
              title: Text(LocaleKeys.activity_refresh_rate_title).tr(),
              subtitle: Text(_activityRefreshRateDisplay(refreshRate)),
              // onTap: () async => await showDialog(
              //   context: context,
              //   builder: (context) => ActivityRefreshRateDialog(
              //     initalValue: refreshRate,
              //   ),
              // ),
            );
          },
        ),
        CupertinoListTile.notched(
          leading: FaIcon(
            FontAwesomeIcons.wrench,
            color: TautulliColorPalette.notWhite,
          ),
          trailing: CupertinoListTileChevron(),
          title: Text(LocaleKeys.advanced_title).tr(),
          // onTap: () => Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const AdvancedPage(),
          //   ),
          // ),
        ),
        CupertinoListTile.notched(
          leading: FaIcon(
            FontAwesomeIcons.palette,
            color: TautulliColorPalette.notWhite,
          ),
          trailing: CupertinoListTileChevron(),
          title: Text(LocaleKeys.themes_title).tr(),
          // onTap: () => Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const ThemePage(),
          //   ),
          // ),
        ),
        CupertinoListTile.notched(
          leading: FaIcon(
            FontAwesomeIcons.universalAccess,
            color: TautulliColorPalette.notWhite,
          ),
          trailing: CupertinoListTileChevron(),
          title: Text(LocaleKeys.accessibility_title).tr(),
          // onTap: () => Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const AccessibilityPage(),
          //   ),
          // ),
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
