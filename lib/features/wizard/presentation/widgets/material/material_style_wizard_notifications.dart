import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/helpers/permission_helper.dart';
import '../../../../../core/types/wizard_skip_type.dart';
import '../../../../../core/widgets/material/material_style_card.dart';
import '../../../../../core/widgets/material/dialogs/material_style_permission_setting_dialog.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../push/presentation/pages/material/material_style_notifications_privacy_page.dart';
import '../../../../settings/presentation/widgets/material/list_tiles/material_style_toggle_settings_list_tile.dart';
import '../../bloc/wizard_bloc.dart';
import 'buttons/material_style_wizard_next_button.dart';
import 'buttons/material_style_wizard_previous_button.dart';
import 'buttons/material_style_wizard_skip_button.dart';
import 'material_style_wizard_stepper.dart';

class MaterialStyleWizardNotifications extends StatelessWidget {
  const MaterialStyleWizardNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocBuilder<WizardBloc, WizardState>(
      builder: (context, state) {
        state as WizardInitial;

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        LocaleKeys.wizard_notifications_title,
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
                                      LocaleKeys.wizard_notifications_text_1,
                                      textAlign: TextAlign.center,
                                    ).tr(),
                                    const Gap(8),
                                    const Text(
                                      LocaleKeys.wizard_notifications_text_2,
                                      textAlign: TextAlign.center,
                                    ).tr(),
                                    const Gap(8),
                                    const Text(
                                      LocaleKeys.wizard_notifications_text_3,
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
                            LocaleKeys.wizard_notifications_view_privacy_title,
                          ).tr(),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => const MaterialStyleNotificationsPrivacyPage(
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
                        child: MaterialStyleToggleSettingsListTile(
                          titleIsTwoLines: true,
                          leading: FaIcon(
                            FontAwesomeIcons.solidBell,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          title: LocaleKeys.wizard_notifications_allow_title.tr(),
                          value: state.notificationsAllowed,
                          onChanged: (_) async {
                            final status = await PermissionHelper.requestNotification();
                            if (status == null) return;
                            if (status.isGranted) {
                              context.read<WizardBloc>().add(
                                WizardToggleNotifications(),
                              );
                            } else {
                              await showDialog(
                                context: context,
                                builder: (context) => MaterialStylePermissionSettingDialog(
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
              ),
              MaterialStyleWizardStepper(
                leftAction: const MaterialStyleWizardPreviousButton(),
                rightAction: state.notificationsSkipped || state.notificationsAllowed
                    ? const MaterialStyleWizardNextButton()
                    : const MaterialStyleWizardSkipButton(
                        wizardSkipType: WizardSkipType.notifications,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
