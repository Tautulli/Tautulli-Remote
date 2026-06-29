import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/material/groups/material_style_dynamic_color_group.dart';
import '../../widgets/material/groups/material_style_styles_group.dart';
import '../../widgets/material/groups/material_style_theme_enhancements_group.dart';
import '../../widgets/material/groups/material_style_themes_group.dart';

class MaterialStyleAppearancePage extends StatelessWidget {
  const MaterialStyleAppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialStyleAppearanceView();
  }
}

class MaterialStyleAppearanceView extends StatelessWidget {
  const MaterialStyleAppearanceView({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.appearance_title).tr(),
      ),
      body: MaterialStylePageBody(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: const [
            MaterialStyleStylesGroup(),
            Gap(8),
            MaterialStyleThemesGroup(),
            Gap(8),
            MaterialStyleDynamicColorGroup(),
            Gap(8),
            MaterialStyleThemeEnhancementsGroup(),
          ],
        ),
      ),
    );
  }
}
