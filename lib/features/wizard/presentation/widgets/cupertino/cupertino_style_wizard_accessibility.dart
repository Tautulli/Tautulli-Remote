import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/ios/custom_cupertino_list_section_heading.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/widgets/cupertino/groups/cupertino_style_accessibility_font_group.dart';
import '../../../../settings/presentation/widgets/cupertino/groups/cupertino_style_accessibility_theme_group.dart';
import '../../../../settings/presentation/widgets/cupertino/groups/cupertino_style_accessibility_visuals_group.dart';

class CupertinoStyleWizardAccessibility extends StatelessWidget {
  const CupertinoStyleWizardAccessibility({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          LocaleKeys.accessibility_title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ).tr(),
        const Gap(8),
        const Text(
          LocaleKeys.wizard_accessibility_text_1,
          textAlign: TextAlign.center,
        ).tr(),
        const Gap(8),
        const Text(
          LocaleKeys.wizard_accessibility_text_2,
          textAlign: TextAlign.center,
        ).tr(),
        CustomCupertinoListSectionHeading(LocaleKeys.font_title.tr()),
        const CupertinoStyleAccessibilityFontGroup(isWizard: true),
        CustomCupertinoListSectionHeading(LocaleKeys.theme_title.tr()),
        const CupertinoStyleAccessibilityThemeGroup(isWizard: true),
        CustomCupertinoListSectionHeading(LocaleKeys.visuals_title.tr()),
        const CupertinoStyleAccessibilityVisualsGroup(isWizard: true),
        //TODO: Add an example card to show effect of disabling backgrounds
      ],
    );
  }
}
