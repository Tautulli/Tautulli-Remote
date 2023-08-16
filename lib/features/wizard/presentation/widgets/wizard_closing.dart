import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/notice_card.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/wizard_bloc.dart';
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
            child: SingleChildScrollView(
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
                    leading: FaIcon(
                      FontAwesomeIcons.bullhorn,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    title: LocaleKeys.wizard_closing_announcements.tr(),
                  ),
                  const Gap(8),
                  NoticeCard(
                    leading: FaIcon(
                      FontAwesomeIcons.handshakeSimple,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    title: LocaleKeys.wizard_closing_support.tr(),
                  ),
                  BlocBuilder<WizardBloc, WizardState>(
                    builder: (context, state) {
                      state as WizardInitial;

                      if (state.oneSignalAllowed) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Gap(8),
                            NoticeCard(
                              leading: FaIcon(
                                FontAwesomeIcons.solidBell,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              title: LocaleKeys.wizard_closing_notifications.tr(),
                            ),
                          ],
                        );
                      }
                      return const SizedBox(height: 0, width: 0);
                    },
                  ),
                  const Gap(8),
                  NoticeCard(
                    leading: FaIcon(
                      FontAwesomeIcons.language,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    title: LocaleKeys.wizard_closing_translate.tr(),
                  ),
                ],
              ),
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
