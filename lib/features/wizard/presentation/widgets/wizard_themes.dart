import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/widgets/groups/dynamic_color_group.dart';
import '../../../settings/presentation/widgets/groups/theme_enhancements_group.dart';
import '../../../settings/presentation/widgets/groups/themes_group.dart';
import 'wizard_next_button.dart';
import 'wizard_previous_button.dart';
import 'wizard_stepper.dart';

class WizardThemes extends StatelessWidget {
  const WizardThemes({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    LocaleKeys.themes_title,
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
                                  LocaleKeys.wizard_theme_text_1,
                                  textAlign: TextAlign.center,
                                ).tr(),
                                const Gap(8),
                                const Text(
                                  LocaleKeys.wizard_theme_text_2,
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
                  const ThemesGroup(),
                  const Gap(8),
                  const DynamicColorGroup(),
                  const Gap(8),
                  const ThemeEnhancementsGroup(),
                ],
              ),
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
