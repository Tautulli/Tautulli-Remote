import 'package:easy_localization/easy_localization.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';
import '../../translations/locale_keys.g.dart';
import '../global_keys/global_keys.dart';

void initalizeQuickActions(QuickActions quickActions) {
  setupQuickActions(quickActions);
  handleQuickActions(quickActions);
}

void setupQuickActions(QuickActions quickActions) {
  quickActions.setShortcutItems(<ShortcutItem>[
    ShortcutItem(
      type: '/activity',
      localizedTitle: LocaleKeys.activity_title.tr(),
      icon: 'activity_quick_action_icon',
    ),
    ShortcutItem(
      type: '/history',
      localizedTitle: LocaleKeys.history_title.tr(),
      icon: 'history_quick_action_icon',
    ),
    ShortcutItem(
      type: '/recent',
      localizedTitle: LocaleKeys.recently_added_title.tr(),
      icon: 'recent_quick_action_icon',
    ),
    // ShortcutItem(
    //   type: '/libraries',
    //   localizedTitle: LocaleKeys.libraries_title.tr(),
    //   icon: 'libraries_quick_action_icon',
    // ),
    // ShortcutItem(
    //   type: '/users',
    //   localizedTitle: LocaleKeys.users_title.tr(),
    //   icon: 'users_quick_action_icon',
    // ),
    // ShortcutItem(
    //   type: '/statistics',
    //   localizedTitle: LocaleKeys.statistics_title.tr(),
    //   icon: 'stats_quick_action_icon',
    // ),
    // ShortcutItem(
    //   type: '/graphs',
    //   localizedTitle: LocaleKeys.graphs_title.tr(),
    //   icon: 'graphs_quick_action_icon',
    // ),
    ShortcutItem(
      type: '/settings',
      localizedTitle: LocaleKeys.settings_title.tr(),
      icon: 'settings_quick_action_icon',
    ),
  ]);
}

void handleQuickActions(QuickActions quickActions) {
  quickActions.initialize((String shortcutType) {
    try {
      navigatorKey.currentState?.pushReplacementNamed(shortcutType);
    } catch (e) {
      di.sl<Logging>().error('QuickActions :: Failed to launch route $shortcutType [$e]');
    }
  });
}
