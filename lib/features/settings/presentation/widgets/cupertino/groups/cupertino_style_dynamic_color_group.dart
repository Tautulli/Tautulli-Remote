import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:system_theme/system_theme.dart';

import '../../../../../../core/device_info/device_info.dart';
import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/types/theme_type.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../dependency_injection.dart' as di;
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleDynamicColorGroup extends StatelessWidget {
  final bool isWizard;

  const CupertinoStyleDynamicColorGroup({
    super.key,
    this.isWizard = false,
  });

  @override
  Widget build(BuildContext context) {
    late Color pickerColor;

    return CupertinoStyleListSection(
      margin: isWizard ? const EdgeInsets.only(bottom: 10) : null,
      headerText: isWizard ? null : LocaleKeys.dynamic_color_title.tr(),
      children: [
        if (di.sl<DeviceInfo>().platform != 'ios')
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              final bool themeNotDynamic = state.appSettings.theme != ThemeType.dynamic;
              final bool supportsAccentColor = defaultTargetPlatform.supportsAccentColor;

              return CupertinoStyleNotchedCupertinoListTile(
                inactive: themeNotDynamic || !supportsAccentColor,
                leading: Icon(
                  CupertinoIcons.wand_stars,
                  color: (themeNotDynamic || !supportsAccentColor)
                      ? CupertinoColors.inactiveGray
                      : ThemeHelper.cupertinoListTileIconColor(),
                  size: 30,
                ),
                trailing: CupertinoSwitch(
                  value: state.appSettings.themeUseSystemColor,
                  onChanged: (themeNotDynamic || !supportsAccentColor)
                      ? null
                      : (value) {
                          context.read<SettingsBloc>().add(
                            SettingsUpdateThemeUseSystemColor(value),
                          );
                        },
                ),
                titleText: LocaleKeys.system_color_title.tr(),
              );
            },
          ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            final bool themeNotDynamic = state.appSettings.theme != ThemeType.dynamic;
            final bool useSystemColor = state.appSettings.themeUseSystemColor;
            pickerColor = state.appSettings.themeCustomColor;

            return CupertinoStyleNotchedCupertinoListTile(
              inactive: themeNotDynamic || useSystemColor,
              leading: Icon(
                CupertinoIcons.eyedropper_halffull,
                color: (themeNotDynamic || useSystemColor)
                    ? CupertinoColors.inactiveGray
                    : ThemeHelper.cupertinoListTileIconColor(),
                size: 25,
              ),
              additionalInfo: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.circle_fill,
                    color: themeNotDynamic || useSystemColor
                        ? state.appSettings.themeCustomColor.withValues(alpha: 0.7)
                        : state.appSettings.themeCustomColor,
                  ),
                ],
              ),
              trailing: const CupertinoListTileChevron(),
              titleText: LocaleKeys.custom_color_title.tr(),
              onTap: () => (themeNotDynamic || useSystemColor)
                  ? null
                  : showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        content: Material(
                          color: Colors.transparent,
                          child: ColorPicker(
                            color: state.appSettings.themeCustomColor,
                            pickersEnabled: const {
                              ColorPickerType.primary: false,
                              ColorPickerType.accent: false,
                              ColorPickerType.wheel: true,
                            },
                            showColorCode: true,
                            colorCodeHasColor: true,
                            enableShadesSelection: false,
                            columnSpacing: 14,
                            padding: const EdgeInsetsGeometry.all(0),
                            copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                              copyFormat: ColorPickerCopyFormat.hexRRGGBB,
                            ),
                            onColorChanged: (value) {
                              pickerColor = value;
                            },
                          ),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(LocaleKeys.close_title).tr(),
                          ),
                          CupertinoDialogAction(
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
