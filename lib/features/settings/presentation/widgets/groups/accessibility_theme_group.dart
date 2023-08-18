import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/types/theme_enhancement_type.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';
import '../list_tiles/checkbox_settings_list_tile.dart';

class AccessibilityThemeGroup extends StatelessWidget {
  const AccessibilityThemeGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: LocaleKeys.theme_title.tr(),
      listTiles: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return CheckboxSettingsListTile(
              value: state.appSettings.themeEnhancement == ThemeEnhancementType.ultraContrastDark,
              leading: FaIcon(
                FontAwesomeIcons.circleHalfStroke,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.high_contrast_title.tr(),
              onChanged: (value) {
                final themeEnhancementType = value == true ? ThemeEnhancementType.ultraContrastDark : ThemeEnhancementType.none;

                context.read<SettingsBloc>().add(
                      SettingsUpdateThemeEnhancement(themeEnhancementType),
                    );
              },
            );
          },
        ),
      ],
    );
  }
}
