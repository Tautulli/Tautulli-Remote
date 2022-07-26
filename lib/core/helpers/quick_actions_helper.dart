import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';
import '../../translations/locale_keys.g.dart';

void initalizeQuickActions(BuildContext context, QuickActions quickActions) {
  setupQuickActions(quickActions);
  handleQuickActions(context, quickActions);
}

void setupQuickActions(QuickActions quickActions) {
  quickActions.setShortcutItems(<ShortcutItem>[
    // NOTE: This second action icon will only work on Android.
    // In a real world project keep the same file name for both platforms.
    ShortcutItem(
      type: '/settings',
      localizedTitle: LocaleKeys.settings_title.tr(),
      icon: 'settings_icon',
    ),
  ]);
}

void handleQuickActions(BuildContext context, QuickActions quickActions) {
  quickActions.initialize((String shortcutType) {
    final route = ModalRoute.of(context);

    if (route?.settings.name != shortcutType) {
      try {
        Navigator.of(context).pushReplacementNamed(shortcutType);
      } catch (e) {
        di.sl<Logging>().error('QuickActions :: Failed to launch route $shortcutType [$e]');
      }
    }
  });
}
