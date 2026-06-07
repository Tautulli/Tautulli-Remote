import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/ios/custom_cupertino_list_section_heading.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/widgets/ios/groups/appearance_enhancements_ios_group.dart';
import '../../../../settings/presentation/widgets/ios/groups/dynamic_color_ios_group.dart';
import '../../../../settings/presentation/widgets/ios/groups/themes_ios_group.dart';

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
        CustomCupertinoListSectionHeading(LocaleKeys.themes_title.tr()),
        const ThemesIosGroup(isWizard: true),
        CustomCupertinoListSectionHeading(LocaleKeys.dynamic_color_title.tr()),
        const DynamicColorIosGroup(isWizard: true),
        CustomCupertinoListSectionHeading(LocaleKeys.enhancements_title.tr()),
        const AppearanceEnhancementsIosGroup(isWizard: true),
      ],
    );
  }
}
