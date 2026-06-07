import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_list_section_heading.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/widgets/cupertino/groups/cupertino_style_appearance_enhancements_group.dart';
import '../../../../settings/presentation/widgets/cupertino/groups/cupertino_style_dynamic_color_group.dart';
import '../../../../settings/presentation/widgets/cupertino/groups/cupertino_style_themes_group.dart';

class CupertinoStyleWizardAppearance extends StatelessWidget {
  const CupertinoStyleWizardAppearance({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //TODO: Needs translation string
        const Text(
          'Appearance',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        const Gap(8),
        const Text(
          LocaleKeys.wizard_theme_text_1,
          textAlign: TextAlign.center,
        ).tr(),
        const Gap(8),
        const Text(
          LocaleKeys.wizard_theme_text_2,
          textAlign: TextAlign.center,
        ).tr(),
        CupertinoStyleListSectionHeading(LocaleKeys.themes_title.tr()),
        const CupertinoStyleThemesGroup(isWizard: true),
        CupertinoStyleListSectionHeading(LocaleKeys.dynamic_color_title.tr()),
        const CupertinoStyleDynamicColorGroup(isWizard: true),
        CupertinoStyleListSectionHeading(LocaleKeys.enhancements_title.tr()),
        const CupertinoStyleAppearanceEnhancementsGroup(isWizard: true),
      ],
    );
  }
}
