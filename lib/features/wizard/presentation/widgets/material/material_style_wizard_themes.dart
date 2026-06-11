import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/material/material_style_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/widgets/material/groups/material_style_dynamic_color_group.dart';
import '../../../../settings/presentation/widgets/material/groups/material_style_theme_enhancements_group.dart';
import '../../../../settings/presentation/widgets/material/groups/material_style_themes_group.dart';
import 'buttons/material_style_wizard_next_button.dart';
import 'buttons/material_style_wizard_previous_button.dart';
import 'material_style_wizard_stepper.dart';

class MaterialStyleWizardThemes extends StatelessWidget {
  const MaterialStyleWizardThemes({super.key});

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
                        child: MaterialStyleCard(
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
                  const MaterialStyleThemesGroup(),
                  const Gap(8),
                  const MaterialStyleDynamicColorGroup(),
                  const Gap(8),
                  const MaterialStyleThemeEnhancementsGroup(),
                ],
              ),
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
