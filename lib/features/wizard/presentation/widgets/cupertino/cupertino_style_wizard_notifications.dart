import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/helpers/permission_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/cupertino/dialogs/cupertino_style_permission_setting_dialog.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../push/presentation/pages/cupertino/cupertino_style_notifications_privacy_page.dart';
import '../../bloc/wizard_bloc.dart';

class CupertinoStyleWizardNotifications extends StatelessWidget {
  const CupertinoStyleWizardNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return Column(
      children: [
        const Text(
          LocaleKeys.wizard_notifications_title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ).tr(),
        const Gap(8),
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
        const Gap(16),
        CupertinoStyleListSection(
          hasLeading: false,
          margin: EdgeInsets.zero,
          children: [
            CupertinoStyleNotchedCupertinoListTile(
              titleText: LocaleKeys.wizard_notifications_view_privacy_title.tr(),
              trailing: const CupertinoListTileChevron(),
              onTap: () => Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const CupertinoStyleNotificationsPrivacyPage(
                    showToggle: false,
                  ),
                ),
              ),
            ),
            CupertinoStyleNotchedCupertinoListTile(
              titleText: LocaleKeys.wizard_notifications_consent_switch_title.tr(),
              subtitleText: LocaleKeys.wizard_notifications_allow_title.tr(),
              trailing: BlocBuilder<WizardBloc, WizardState>(
                builder: (context, wizardState) {
                  wizardState as WizardInitial;

                  return CupertinoSwitch(
                    value: wizardState.notificationsAllowed,
                    onChanged: (_) async {
                      final status = await PermissionHelper.requestNotification();
                      if (status == null) return;
                      if (status.isGranted) {
                        context.read<WizardBloc>().add(
                          WizardToggleNotifications(),
                        );
                      } else {
                        await showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoStylePermissionSettingDialog(
                            title: LocaleKeys.notification_permission_dialog_title.tr(),
                            content: LocaleKeys.notification_permission_dialog_content.tr(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
