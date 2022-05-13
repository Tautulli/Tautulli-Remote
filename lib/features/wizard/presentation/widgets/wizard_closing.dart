import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/notice_card.dart';
import '../../../../translations/locale_keys.g.dart';
import 'wizard_finish_button.dart';
import 'wizard_previous_button.dart';
import 'wizard_stepper.dart';

class WizardClosing extends StatelessWidget {
  const WizardClosing({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  LocaleKeys.wizard_closing_title,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ).tr(),
                const Gap(8),
                NoticeCard(
                  leading: const FaIcon(FontAwesomeIcons.bullhorn),
                  title: LocaleKeys.wizard_closing_announcements.tr(),
                ),
                const Gap(8),
                NoticeCard(
                  leading: const FaIcon(FontAwesomeIcons.handshakeSimple),
                  title: LocaleKeys.wizard_closing_support.tr(),
                ),
                const Gap(8),
                NoticeCard(
                  leading: const FaIcon(FontAwesomeIcons.solidBell),
                  title: LocaleKeys.wizard_closing_notifications.tr(),
                ),
                const Gap(8),
                NoticeCard(
                  leading: const FaIcon(FontAwesomeIcons.language),
                  title: LocaleKeys.wizard_closing_translate.tr(),
                ),
              ],
            ),
          ),
          const WizardStepper(
            leftAction: WizardPreviousButton(),
            rightAction: WizardFinishButton(),
          ),
        ],
      ),
    );
  }
}
