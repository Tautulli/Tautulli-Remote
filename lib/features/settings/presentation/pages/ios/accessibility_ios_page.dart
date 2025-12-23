import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/groups/accessibility_font_ios_group.dart';
import '../../widgets/ios/groups/accessibility_theme_ios_group.dart';
import '../../widgets/ios/groups/accessibility_visuals_ios_group.dart';

class AccessibilityIosPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const AccessibilityIosPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AccessibilityIosView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class AccessibilityIosView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const AccessibilityIosView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
      middle: const Text(LocaleKeys.accessibility_title).tr(),
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
