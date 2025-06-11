import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:system_theme/system_theme.dart';

import '../../../../../../core/device_info/device_info.dart';
import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/types/theme_type.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../dependency_injection.dart' as di;
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class DynamicColorIosGroup extends StatelessWidget {
  const DynamicColorIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    late Color pickerColor;

    return CustomCupertinoListSection(
      headerText: LocaleKeys.dynamic_color_title.tr(),
      children: [
        if (di.sl<DeviceInfo>().platform != 'ios')
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              final bool themeNotDynamic = state.appSettings.theme != ThemeType.dynamic;
              final bool supportsAccentColor = defaultTargetPlatform.supportsAccentColor;

              return CustomNotchedCupertinoListTile(
                leading: FaIcon(
                  FontAwesomeIcons.wandMagicSparkles,
                  color: (themeNotDynamic || !supportsAccentColor) ? CupertinoColors.inactiveGray : ThemeHelper.cupertinoListTileIconColor(),
                  size: 21.3,
                ),
                trailing: CupertinoSwitch(
                  value: state.appSettings.themeUseSystemColor,
                  onChanged: themeNotDynamic || !supportsAccentColor
                      ? null
                      : (value) {
                          context.read<SettingsBloc>().add(
                                SettingsUpdateThemeUseSystemColor(value),
                              );
                        },
                ),
                title: Text(
                  LocaleKeys.system_color_title,
                  style: TextStyle(
                    color: (themeNotDynamic || !supportsAccentColor) ? CupertinoColors.inactiveGray : null,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
              );
            },
          ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            final bool themeNotDynamic = state.appSettings.theme != ThemeType.dynamic;
            final bool useSystemColor = state.appSettings.themeUseSystemColor;
            pickerColor = state.appSettings.themeCustomColor;

            return CustomNotchedCupertinoListTile(
              leading: FaIcon(
                FontAwesomeIcons.palette,
                color: (themeNotDynamic || useSystemColor) ? CupertinoColors.inactiveGray : null,
                size: 23,
              ),
              additionalInfo: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidCircle,
                    color: themeNotDynamic || useSystemColor ? state.appSettings.themeCustomColor.withValues(alpha: 0.7) : state.appSettings.themeCustomColor,
                  ),
                ],
              ),
              trailing: const CupertinoListTileChevron(),
              title: Text(
                LocaleKeys.custom_color_title,
                style: TextStyle(
                  color: (themeNotDynamic || useSystemColor) ? CupertinoColors.inactiveGray : null,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              onTap: () => showCupertinoDialog(
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
