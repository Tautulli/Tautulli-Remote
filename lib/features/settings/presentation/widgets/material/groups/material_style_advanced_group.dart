import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/helpers/string_helper.dart';
import '../../../../../../core/helpers/translation_helper.dart';
import '../../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../../core/widgets/material/material_style_list_tile_group.dart';
import '../../../../../../dependency_injection.dart' as di;
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../translation/presentation/bloc/translation_bloc.dart';
import '../../../bloc/settings_bloc.dart';
import '../bottom_sheets/material_style_home_page_bottom_sheet.dart';
import '../bottom_sheets/material_style_language_bottom_sheet.dart';
import '../list_tiles/material_style_toggle_settings_list_tile.dart';

class MaterialStyleAdvancedGroup extends StatelessWidget {
  const MaterialStyleAdvancedGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialStyleListTileGroup(
      heading: LocaleKeys.settings_title.tr(),
      listTiles: [
        if (defaultTargetPlatform == TargetPlatform.android)
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;
              final doubleBackToExit = state.appSettings.doubleBackToExit;

              return MaterialStyleToggleSettingsListTile(
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

            return MaterialStyleToggleSettingsListTile(
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

            return MaterialStyleToggleSettingsListTile(
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

            return MaterialStyleToggleSettingsListTile(
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

            return MaterialStyleListTile(
              leading: FaIcon(
                FontAwesomeIcons.solidHouse,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.home_page_title.tr(),
              subtitle: StringHelper.mapHomePageSettingToTitle(homePageSetting),
              onTap: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => MaterialStyleHomePageBottomSheet(
                    initialValue: homePageSetting,
                  ),
                );
              },
            );
          },
        ),
        MaterialStyleListTile(
          leading: FaIcon(
            FontAwesomeIcons.language,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: LocaleKeys.language_title.tr(),
          subtitle: TranslationHelper.localeToString(context.locale),
          onTap: () async {
            await showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (sheetContext) => BlocProvider(
                create: (_) => di.sl<TranslationBloc>(),
                child: MaterialStyleLanguageBottomSheet(
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
