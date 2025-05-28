import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';
import '../../pages/accessibility_page.dart';
import '../../pages/advanced_page.dart';
import '../../pages/theme_page.dart';
import '../dialogs/activity_refresh_rate_dialog.dart';
import '../dialogs/server_timeout_dialog.dart';

class AppSettingsGroup extends StatelessWidget {
  const AppSettingsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: LocaleKeys.settings_and_operations_title.tr(),
      listTiles: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final serverTimeout = state.appSettings.serverTimeout;

            return CustomListTile(
              leading: FaIcon(
                FontAwesomeIcons.stopwatch,
                size: 28,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.server_timeout_title.tr(),
              subtitle: _serverTimeoutDisplay(serverTimeout),
              onTap: () async => await showDialog(
                context: context,
                builder: (context) => ServerTimeoutDialog(
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

            return CustomListTile(
              leading: FaIcon(
                FontAwesomeIcons.solidClock,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.activity_refresh_rate_title.tr(),
              subtitle: _activityRefreshRateDisplay(refreshRate),
              onTap: () async => await showDialog(
                context: context,
                builder: (context) => ActivityRefreshRateDialog(
                  initalValue: refreshRate,
                ),
              ),
            );
          },
        ),
        CustomListTile(
          leading: FaIcon(
            FontAwesomeIcons.wrench,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: LocaleKeys.advanced_title.tr(),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdvancedPage(),
            ),
          ),
        ),
        CustomListTile(
          leading: FaIcon(
            FontAwesomeIcons.palette,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: LocaleKeys.themes_title.tr(),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ThemePage(),
            ),
          ),
        ),
        CustomListTile(
          leading: FaIcon(
            FontAwesomeIcons.universalAccess,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: LocaleKeys.accessibility_title.tr(),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AccessibilityPage(),
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
