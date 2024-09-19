import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/page_body.dart';
import '../../../../translations/locale_keys.g.dart';
import '../widgets/groups/dynamic_color_group.dart';
import '../widgets/groups/theme_enhancements_group.dart';
import '../widgets/groups/themes_group.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemeView();
  }
}

class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.themes_title).tr(),
      ),
      body: PageBody(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: const [
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
