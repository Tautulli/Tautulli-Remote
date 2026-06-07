import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/types/theme_enhancement_type.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleAccessibilityThemeGroup extends StatelessWidget {
  final bool isWizard;

  const CupertinoStyleAccessibilityThemeGroup({
    super.key,
    this.isWizard = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleListSection(
      margin: isWizard ? const EdgeInsets.only(bottom: 10) : null,
      headerText: isWizard ? null : LocaleKeys.theme_title.tr(),
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return CupertinoStyleNotchedCupertinoListTile(
              leading: Icon(
                CupertinoIcons.circle_lefthalf_fill,
                color: ThemeHelper.cupertinoListTileIconColor(),
              ),
              trailing: CupertinoSwitch(
                value: state.appSettings.themeEnhancement == ThemeEnhancementType.ultraContrastDark,
                onChanged: (value) {
                  final themeEnhancementType = value == true
                      ? ThemeEnhancementType.ultraContrastDark
                      : ThemeEnhancementType.none;

                  context.read<SettingsBloc>().add(
                    SettingsUpdateThemeEnhancement(themeEnhancementType),
                  );
                },
              ),
              titleText: LocaleKeys.high_contrast_title.tr(),
            );
          },
        ),
      ],
    );
  }
}
