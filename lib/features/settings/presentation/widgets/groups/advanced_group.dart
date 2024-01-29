import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/device_info/device_info.dart';
import '../../../../../core/helpers/string_helper.dart';
import '../../../../../core/helpers/translation_helper.dart';
import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../translation/presentation/bloc/translation_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../dialogs/home_page_dialog.dart';
import '../dialogs/language_dialog.dart';
import '../list_tiles/checkbox_settings_list_tile.dart';

class AdvancedGroup extends StatelessWidget {
  const AdvancedGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: LocaleKeys.settings_title.tr(),
      listTiles: [
        if (di.sl<DeviceInfo>().platform == 'android')
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;
              final doubleBackToExit = state.appSettings.doubleBackToExit;

              return CheckboxSettingsListTile(
                leading: FaIcon(
                  FontAwesomeIcons.anglesLeft,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: LocaleKeys.double_back_to_exit_title.tr(),
                subtitle: LocaleKeys.double_back_to_exit_subtitle.tr(),
                value: doubleBackToExit,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(
                          SettingsUpdateDoubleBackToExit(value),
                        );
                  }
                },
              );
            },
          ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final maskSensitiveInfo = state.appSettings.maskSensitiveInfo;

            return CheckboxSettingsListTile(
              subtitleIsTwoLines: true,
              leading: FaIcon(
                FontAwesomeIcons.solidEyeSlash,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.mask_senstivie_info_title.tr(),
              subtitle: LocaleKeys.mask_senstivie_info_subtitle.tr(),
              value: maskSensitiveInfo,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        SettingsUpdateMaskSensitiveInfo(value),
                      );
                }
              },
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final multiserverActivity = state.appSettings.multiserverActivity;

            return CheckboxSettingsListTile(
              subtitleIsTwoLines: true,
              leading: FaIcon(
                FontAwesomeIcons.barsStaggered,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.multiserver_activity_page_title.tr(),
              subtitle: LocaleKeys.multiserver_activity_page_subtitle.tr(),
              value: multiserverActivity,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        SettingsUpdateMultiserverActivity(value),
                      );
                }
              },
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final libraryMediaFullRefresh = state.appSettings.libraryMediaFullRefresh;

            return CheckboxSettingsListTile(
              subtitleIsTwoLines: true,
              leading: FaIcon(
                FontAwesomeIcons.arrowRotateRight,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.library_media_full_refresh_title.tr(),
              subtitle: LocaleKeys.library_media_full_refresh_subtitle.tr(),
              value: libraryMediaFullRefresh,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        SettingsUpdateLibraryMediaFullRefresh(value),
                      );
                }
              },
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final homePageSetting = state.appSettings.homePage;

            return CustomListTile(
              leading: FaIcon(
                FontAwesomeIcons.house,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.home_page_title.tr(),
              subtitle: StringHelper.mapHomePageSettingToTitle(homePageSetting),
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) => HomePageDialog(
                    initialValue: homePageSetting,
                  ),
                );
              },
            );
          },
        ),
        CustomListTile(
          leading: FaIcon(
            FontAwesomeIcons.language,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: LocaleKeys.language_title.tr(),
          subtitle: TranslationHelper.localeToString(context.locale),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => di.sl<TranslationBloc>(),
                child: LanguageDialog(
                  initialValue: context.locale,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
