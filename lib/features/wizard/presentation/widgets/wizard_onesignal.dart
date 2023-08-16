import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../../../core/widgets/permission_setting_dialog.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../onesignal/presentation/pages/onesignal_data_privacy.dart';
import '../../../settings/presentation/widgets/list_tiles/checkbox_settings_list_tile.dart';
import '../bloc/wizard_bloc.dart';
import 'wizard_next_button.dart';
import 'wizard_previous_button.dart';
import 'wizard_skip_button.dart';
import 'wizard_stepper.dart';

class WizardOneSignal extends StatelessWidget {
  const WizardOneSignal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardBloc, WizardState>(
      builder: (context, state) {
        state as WizardInitial;

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      LocaleKeys.onesignal_data_privacy_title,
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
                                    LocaleKeys.wizard_onesignal_text_1,
                                    textAlign: TextAlign.center,
                                  ).tr(),
                                  const Gap(8),
                                  const Text(
                                    LocaleKeys.wizard_onesignal_text_2,
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
                    const Divider(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.onSurface,
                        ),
                        child: const Text(
                          LocaleKeys.view_onesignal_privacy_title,
                        ).tr(),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => const OneSignalDataPrivacyPage(
                                showToggle: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Gap(8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CheckboxSettingsListTile(
                        titleIsTwoLines: true,
                        leading: WebsafeSvg.asset(
                          'assets/logos/onesignal.svg',
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                          height: 35,
                        ),
                        title: LocaleKeys.wizard_onesignal_allow_title.tr(),
                        value: state.oneSignalAllowed,
                        onChanged: (_) async {
                          if (await Permission.notification.request().isGranted) {
                            context.read<WizardBloc>().add(
                                  WizardToggleOneSignal(),
                                );
                          } else {
                            await showDialog(
                              context: context,
                              builder: (context) => PermissionSettingDialog(
                                title: LocaleKeys.notification_permission_dialog_title.tr(),
                                content: LocaleKeys.notification_permission_dialog_content.tr(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              WizardStepper(
                leftAction: const WizardPreviousButton(),
                rightAction: state.oneSignalSkipped || state.oneSignalAllowed
                    ? const WizardNextButton()
                    : const WizardSkipButton(
                        skipType: SkipType.onesignal,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
