import 'package:easy_localization/easy_localization.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';
import '../../translations/locale_keys.g.dart';
import '../global_keys/global_keys.dart';

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
    ShortcutItem(
      type: '/settings',
      localizedTitle: LocaleKeys.settings_title.tr(),
      icon: 'settings_quick_action_icon',
    ),
  ]);
}

//* Material
void initalizeQuickActions(QuickActions quickActions) {
  setupQuickActions(quickActions);
  handleQuickActions(quickActions);
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

//* Cupertino
void initalizeQuickActionsCupertino(QuickActions quickActions) {
  setupQuickActions(quickActions);
  handleQuickActionsCupertino(quickActions);
}

void handleQuickActionsCupertino(QuickActions quickActions) {
  quickActions.initialize((String shortcutType) {
    try {
      final int? tabIndex = _getTabIndexCupertino(shortcutType);

      if (tabIndex != null) {
        cupertinoTabController.index = tabIndex;
      }
    } catch (e) {
      di.sl<Logging>().error('QuickActions :: Failed to launch route $shortcutType [$e]');
    }
  });
}

int? _getTabIndexCupertino(String shortcutType) {
  switch (shortcutType) {
    case '/activity':
      return 0;
    case '/history':
      return 1;
    case '/recent':
      return 2;
    case '/libraries':
      return 3;
    case '/settings':
      moreNavigationPage.value = 'settings';
      return 4;
    default:
      return null;
  }
}
