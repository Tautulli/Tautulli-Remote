import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/custom_cupertino_navigation_bar_back_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/groups/accessibility_font_ios_group.dart';
import '../../widgets/ios/groups/accessibility_theme_ios_group.dart';
import '../../widgets/ios/groups/accessibility_visuals_ios_group.dart';

class AccessibilityIosPage extends StatelessWidget {
  final String? previousPageTitle;

  const AccessibilityIosPage({
    super.key,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AccessibilityIosView(
      previousPageTitle: previousPageTitle,
    );
  }
}

class AccessibilityIosView extends StatelessWidget {
  final String? previousPageTitle;

  const AccessibilityIosView({
    super.key,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.accessibility_title).tr(),
      leading: CustomCupertinoNavigationBarBackButton(
        previousPageTitle: previousPageTitle,
      ),
      child: ListView(
        children: const [
          AccessibilityFontIosGroup(),
          AccessibilityThemeIosGroup(),
          AccessibilityVisualsIosGroup(),
        ],
      ),
    );
  }
}
