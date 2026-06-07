import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/page_body.dart';
import '../../../../translations/locale_keys.g.dart';
import '../widgets/groups/dynamic_color_group.dart';
import '../widgets/groups/styles_group.dart';
import '../widgets/groups/theme_enhancements_group.dart';
import '../widgets/groups/themes_group.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppearanceView();
  }
}

class AppearanceView extends StatelessWidget {
  const AppearanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.appearance_title).tr(),
      ),
      body: PageBody(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: const [
            StylesGroup(),
            Gap(8),
            ThemesGroup(),
            Gap(8),
            DynamicColorGroup(),
            Gap(8),
            ThemeEnhancementsGroup(),
          ],
        ),
      ),
    );
  }
}
