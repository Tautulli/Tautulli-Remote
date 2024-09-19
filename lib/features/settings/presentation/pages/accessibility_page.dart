import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/page_body.dart';
import '../../../../translations/locale_keys.g.dart';
import '../widgets/groups/accessibility_font_group.dart';
import '../widgets/groups/accessibility_theme_group.dart';
import '../widgets/groups/accessibility_visuals_group.dart';

class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccessibilityView();
  }
}

class AccessibilityView extends StatelessWidget {
  const AccessibilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.accessibility_title).tr(),
      ),
      body: PageBody(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: const [
            AccessibilityFontGroup(),
            Gap(8),
            AccessibilityThemeGroup(),
            Gap(8),
            AccessibilityVisualsGroup(),
          ],
        ),
      ),
    );
  }
}
