import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/card_with_forced_tint.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/widgets/material/groups/material_style_accessibility_font_group.dart';
import '../../../../settings/presentation/widgets/material/groups/material_style_accessibility_theme_group.dart';
import '../../../../settings/presentation/widgets/material/groups/material_style_accessibility_visuals_group.dart';
import 'buttons/material_style_wizard_next_button.dart';
import 'buttons/material_style_wizard_previous_button.dart';
import 'material_style_wizard_stepper.dart';

class MaterialStyleWizardAccessibility extends StatelessWidget {
  const MaterialStyleWizardAccessibility({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  LocaleKeys.accessibility_title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ).tr(),
                const Gap(8),
                Row(
                  children: [
                    Expanded(
                      child: CardWithForcedTint(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                LocaleKeys.wizard_accessibility_text_1,
                                textAlign: TextAlign.center,
                              ).tr(),
                              const Gap(8),
                              const Text(
                                LocaleKeys.wizard_accessibility_text_2,
                                textAlign: TextAlign.center,
                              ).tr(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                const MaterialStyleAccessibilityFontGroup(),
                const Gap(8),
                const MaterialStyleAccessibilityThemeGroup(),
                const Gap(8),
                const MaterialStyleAccessibilityVisualsGroup(),
                const Gap(8),
              ],
            ),
          ),
          const MaterialStyleWizardStepper(
            leftAction: MaterialStyleWizardPreviousButton(),
            rightAction: MaterialStyleWizardNextButton(),
          ),
        ],
      ),
    );
  }
}
