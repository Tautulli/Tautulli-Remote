import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/device_info/device_info.dart';
import '../../../../../core/types/theme_type.dart';
import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';
import '../list_tiles/checkbox_settings_list_tile.dart';

class DynamicColorGroup extends StatelessWidget {
  const DynamicColorGroup({super.key});

  @override
  Widget build(BuildContext context) {
    late Color pickerColor;

    return ListTileGroup(
      heading: LocaleKeys.dynamic_color_title.tr(),
      listTiles: [
        if (di.sl<DeviceInfo>().platform != 'ios')
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              final bool themeNotDynamic = state.appSettings.theme != ThemeType.dynamic;

              return CheckboxSettingsListTile(
                leading: FaIcon(
                  FontAwesomeIcons.wandMagicSparkles,
                  color: themeNotDynamic ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.onSurface,
                ),
                title: LocaleKeys.system_color_title.tr(),
                value: state.appSettings.themeUseSystemColor,
                onChanged: themeNotDynamic
                    ? null
                    : (value) {
                        if (value != null) {
                          context.read<SettingsBloc>().add(
                                SettingsUpdateThemeUseSystemColor(value),
                              );
                        }
                      },
              );
            },
          ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            final bool themeNotDynamic = state.appSettings.theme != ThemeType.dynamic;
            final bool useSystemColor = state.appSettings.themeUseSystemColor;
            pickerColor = state.appSettings.themeCustomColor;

            return CustomListTile(
              leading: FaIcon(
                FontAwesomeIcons.droplet,
                color: themeNotDynamic || useSystemColor ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.custom_color_title.tr(),
              inactive: themeNotDynamic || useSystemColor,
              trailing: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.solidCircle,
                      color: themeNotDynamic || useSystemColor ? state.appSettings.themeCustomColor.withOpacity(0.7) : state.appSettings.themeCustomColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
              onTap: themeNotDynamic || useSystemColor
                  ? null
                  : () async => await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          contentPadding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: state.appSettings.themeCustomColor,
                              hexInputBar: true,
                              enableAlpha: false,
                              onColorChanged: (value) => pickerColor = value,
                            ),
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(LocaleKeys.close_title).tr(),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () {
                                context.read<SettingsBloc>().add(
                                      SettingsUpdateThemeCustomColor(pickerColor),
                                    );
                                Navigator.of(context).pop();
                              },
                              child: const Text(LocaleKeys.select_title).tr(),
                            ),
                          ],
                        ),
                      ),
            );
          },
        ),
      ],
    );
  }
}
