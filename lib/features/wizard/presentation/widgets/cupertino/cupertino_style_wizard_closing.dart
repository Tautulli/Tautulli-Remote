import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_notice_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/wizard_bloc.dart';

class CupertinoStyleWizardClosing extends StatelessWidget {
  const CupertinoStyleWizardClosing({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          LocaleKeys.wizard_closing_title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ).tr(),
        const Gap(8),
        CupertinoStyleNoticeCard(
          leading: Icon(
            CupertinoIcons.dot_radiowaves_left_right,
            color: ThemeHelper.cupertinoCardIconColor(),
          ),
          title: LocaleKeys.wizard_closing_announcements.tr(),
        ),
        const Gap(8),
        CupertinoStyleNoticeCard(
          leading: Icon(
            CupertinoIcons.bubble_left_fill,
            color: ThemeHelper.cupertinoCardIconColor(),
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
                  CupertinoStyleNoticeCard(
                    leading: Icon(
                      CupertinoIcons.bell_fill,
                      color: ThemeHelper.cupertinoCardIconColor(),
                    ),
                    title: LocaleKeys.wizard_closing_notifications.tr(),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const Gap(8),
        CupertinoStyleNoticeCard(
          leading: Icon(
            CupertinoIcons.paintbrush_fill,
            color: ThemeHelper.cupertinoCardIconColor(),
          ),
          title: LocaleKeys.wizard_closing_styles.tr(),
        ),
        const Gap(8),
        CupertinoStyleNoticeCard(
          leading: Icon(
            CupertinoIcons.globe,
            color: ThemeHelper.cupertinoCardIconColor(),
          ),
          title: LocaleKeys.wizard_closing_translate.tr(),
        ),
      ],
    );
  }
}
