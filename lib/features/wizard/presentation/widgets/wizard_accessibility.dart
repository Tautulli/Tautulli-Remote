import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/widgets/groups/accessibility_font_group.dart';
import '../../../settings/presentation/widgets/groups/accessibility_theme_group.dart';
import '../../../settings/presentation/widgets/groups/accessibility_visuals_group.dart';
import 'wizard_next_button.dart';
import 'wizard_previous_button.dart';
import 'wizard_stepper.dart';

class WizardAccessibility extends StatelessWidget {
  const WizardAccessibility({super.key});

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
                const AccessibilityFontGroup(),
                const Gap(8),
                const AccessibilityThemeGroup(),
                const Gap(8),
                const AccessibilityVisualsGroup(),
                const Gap(8),
              ],
            ),
          ),
          const WizardStepper(
            leftAction: WizardPreviousButton(),
            rightAction: WizardNextButton(),
          ),
        ],
      ),
    );
  }
}
