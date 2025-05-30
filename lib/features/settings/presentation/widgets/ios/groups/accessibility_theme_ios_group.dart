import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/types/theme_enhancement_type.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class AccessibilityThemeIosGroup extends StatelessWidget {
  const AccessibilityThemeIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.theme_title.tr(),
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return CupertinoListTile.notched(
              leading: const FaIcon(FontAwesomeIcons.circleHalfStroke),
              trailing: CupertinoSwitch(
                value: state.appSettings.themeEnhancement == ThemeEnhancementType.ultraContrastDark,
                onChanged: (value) {
                  final themeEnhancementType = value == true ? ThemeEnhancementType.ultraContrastDark : ThemeEnhancementType.none;

                  context.read<SettingsBloc>().add(
                        SettingsUpdateThemeEnhancement(themeEnhancementType),
                      );
                },
              ),
              title: const Text(LocaleKeys.high_contrast_title).tr(),
            );
          },
        )
      ],
    );
  }
}
