import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/types/wizard_skip_type.dart';
import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/widgets/material/dialogs/material_style_language_dialog.dart';
import '../../../settings/presentation/widgets/material/groups/material_style_servers_group.dart';
import '../../../settings/presentation/widgets/material/buttons/material_style_register_server_button.dart';
import '../../../translation/presentation/bloc/translation_bloc.dart';
import '../bloc/wizard_bloc.dart';
import 'wizard_exit_button.dart';
import 'wizard_next_button.dart';
import 'wizard_skip_button.dart';
import 'wizard_stepper.dart';

class WizardServers extends StatelessWidget {
  const WizardServers({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    LocaleKeys.wizard_welcome_text_1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ).tr(),
                ),
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
                                LocaleKeys.wizard_welcome_text_2,
                                textAlign: TextAlign.center,
                              ).tr(),
                              const Gap(8),
                              const Text(
                                LocaleKeys.wizard_welcome_text_3,
                                textAlign: TextAlign.center,
                              ).tr(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(6),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.language,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const Gap(8),
                      const Text(LocaleKeys.change_language_title).tr(),
                    ],
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => BlocProvider(
                        create: (context) => di.sl<TranslationBloc>(),
                        child: MaterialStyleLanguageDialog(
                          initialValue: context.locale,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                const MaterialStyleServersGroup(isWizard: true),
                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    state as SettingsSuccess;

                    if (state.serverList.isNotEmpty) return const Gap(8);

                    return const SizedBox(height: 0, width: 0);
                  },
                ),
                const SizedBox(
                  width: double.infinity,
                  child: MaterialStyleRegisterServerButton(),
                ),
              ],
            ),
          ),
          BlocBuilder<WizardBloc, WizardState>(
            builder: (context, wizardState) {
              wizardState as WizardInitial;

              return BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  settingsState as SettingsSuccess;

                  return WizardStepper(
                    leftAction: const WizardExitButton(),
                    rightAction: settingsState.serverList.isEmpty && !wizardState.serversSkipped
                        ? const WizardSkipButton(wizardSkipType: WizardSkipType.servers)
                        : const WizardNextButton(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
