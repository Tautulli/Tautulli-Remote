import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_list_section_heading.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/widgets/cupertino/bottom_sheets/cupertino_style_language_bottom_sheet.dart';
import '../../../../settings/presentation/widgets/cupertino/groups/cupertino_style_servers_group.dart';
import '../../../../settings/presentation/widgets/cupertino/cupertino_style_register_server_button.dart';
import '../../../../translation/presentation/bloc/translation_bloc.dart';

class CupertinoStyleWizardServers extends StatelessWidget {
  const CupertinoStyleWizardServers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          LocaleKeys.wizard_welcome_text_1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ).tr(),
        const Gap(8),
        const Text(
          LocaleKeys.wizard_welcome_text_2,
          textAlign: TextAlign.center,
        ).tr(),
        const Gap(8),
        const Text(
          LocaleKeys.wizard_welcome_text_3,
          textAlign: TextAlign.center,
        ).tr(),
        const Gap(16),
        CupertinoStyleListSection(
          margin: EdgeInsets.zero,
          children: [
            CupertinoStyleNotchedCupertinoListTile(
              leading: Icon(
                CupertinoIcons.globe,
                color: ThemeHelper.cupertinoListTileIconColor(),
              ),
              titleText: LocaleKeys.change_language_title.tr(),
              trailing: const CupertinoListTileChevron(),
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => BlocProvider(
                  create: (context) => di.sl<TranslationBloc>(),
                  child: CupertinoStyleLanguageBottomSheet(
                    initialValue: context.locale,
                  ),
                ),
              ),
            ),
          ],
        ),
        CupertinoStyleListSectionHeading(LocaleKeys.servers_title.tr()),
        const CupertinoStyleServersGroup(isWizard: true),
        const Gap(8),
        const SizedBox(
          width: double.infinity,
          child: CupertinoStyleRegisterServerButton(isWizard: true),
        ),
      ],
    );
  }
}
