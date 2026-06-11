import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/page_body.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/material/groups/material_style_accessibility_font_group.dart';
import '../../widgets/material/groups/material_style_accessibility_theme_group.dart';
import '../../widgets/material/groups/material_style_accessibility_visuals_group.dart';

class MaterialStyleAccessibilityPage extends StatelessWidget {
  const MaterialStyleAccessibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialStyleAccessibilityView();
  }
}

class MaterialStyleAccessibilityView extends StatelessWidget {
  const MaterialStyleAccessibilityView({super.key});

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
            MaterialStyleAccessibilityFontGroup(),
            Gap(8),
            MaterialStyleAccessibilityThemeGroup(),
            Gap(8),
            MaterialStyleAccessibilityVisualsGroup(),
          ],
        ),
      ),
    );
  }
}
