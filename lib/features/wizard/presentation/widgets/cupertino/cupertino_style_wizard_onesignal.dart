import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/permission_setting_ios_dialog.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../onesignal/presentation/pages/cupertino/cupertino_style_onesignal_data_privacy_page.dart';
import '../../bloc/wizard_bloc.dart';

class CupertinoStyleWizardOnesignal extends StatelessWidget {
  const CupertinoStyleWizardOnesignal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          LocaleKeys.onesignal_data_privacy_title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ).tr(),
        const Gap(8),
        const Text(
          LocaleKeys.wizard_onesignal_text_1,
          textAlign: TextAlign.center,
        ).tr(),
        const Gap(8),
        const Text(
          LocaleKeys.wizard_onesignal_text_2,
          textAlign: TextAlign.center,
        ).tr(),
        const Gap(16),
        CustomCupertinoListSection(
          hasLeading: true,
          margin: EdgeInsets.zero,
          children: [
            CustomNotchedCupertinoListTile(
              leading: WebsafeSvg.asset(
                'assets/logos/onesignal.svg',
                colorFilter: ColorFilter.mode(
                  ThemeHelper.cupertinoListTileIconColor(),
                  BlendMode.srcIn,
                ),
              ),
              titleText: LocaleKeys.view_onesignal_privacy_title.tr(),
              trailing: const CupertinoListTileChevron(),
              onTap: () => Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const CupertinoStyleOnesignalDataPrivacyPage(
                    showToggle: false,
                  ),
                ),
              ),
            ),
            CustomNotchedCupertinoListTile(
              titleText: LocaleKeys.onesignal_consent_switch_title.tr(),
              subtitleText: LocaleKeys.wizard_onesignal_allow_title.tr(),
              trailing: BlocBuilder<WizardBloc, WizardState>(
                builder: (context, wizardState) {
                  wizardState as WizardInitial;

                  return CupertinoSwitch(
                    value: wizardState.oneSignalAllowed,
                    onChanged: (_) async {
                      if (await Permission.notification.request().isGranted) {
                        context.read<WizardBloc>().add(
                          WizardToggleOneSignal(),
                        );
                      } else {
                        await showCupertinoDialog(
                          context: context,
                          builder: (context) => PermissionSettingIosDialog(
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
