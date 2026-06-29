import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/cupertino/groups/cupertino_style_accessibility_font_group.dart';
import '../../widgets/cupertino/groups/cupertino_style_accessibility_theme_group.dart';
import '../../widgets/cupertino/groups/cupertino_style_accessibility_visuals_group.dart';

class CupertinoStyleAccessibilityPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleAccessibilityPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleAccessibilityView(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStyleAccessibilityView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleAccessibilityView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStylePageScaffold(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
      middle: const Text(LocaleKeys.accessibility_title).tr(),
      child: ListView(
        children: const [
          CupertinoStyleAccessibilityFontGroup(),
          CupertinoStyleAccessibilityThemeGroup(),
          CupertinoStyleAccessibilityVisualsGroup(),
        ],
      ),
    );
  }
}
