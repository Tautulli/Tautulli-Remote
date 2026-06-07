import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/device_info/device_info.dart';
import '../../../../../../core/helpers/string_helper.dart';
import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/helpers/translation_helper.dart';
import '../../../../../../core/types/app_style.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../dependency_injection.dart' as di;
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../translation/presentation/bloc/translation_bloc.dart';
import '../../../bloc/settings_bloc.dart';
import '../bottom_sheets/home_page_ios_bottom_sheet.dart';
import '../bottom_sheets/language_ios_bottom_sheet.dart';

class AdvancedIosGroup extends StatelessWidget {
  const AdvancedIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;
        final doubleBackToExit = state.appSettings.doubleBackToExit;
        final maskSensitiveInfo = state.appSettings.maskSensitiveInfo;
        final multiserverActivity = state.appSettings.multiserverActivity;
        final libraryMediaFullRefresh = state.appSettings.libraryMediaFullRefresh;
        final homePageSetting = state.appSettings.homePage;
        final appStyle = state.appSettings.appStyle;

        return CustomCupertinoListSection(
          headerText: LocaleKeys.settings_title.tr(),
          children: [
            if (di.sl<DeviceInfo>().platform == 'android')
              CustomNotchedCupertinoListTile(
                leading: Icon(
                  CupertinoIcons.chevron_left_2,
                  color: ThemeHelper.cupertinoListTileIconColor(),
                ),
                trailing: CupertinoSwitch(
                  value: doubleBackToExit,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(
                      SettingsUpdateDoubleBackToExit(value),
                    );
                  },
                ),
                titleText: LocaleKeys.double_back_to_exit_title.tr(),
                subtitleText: LocaleKeys.double_back_to_exit_subtitle.tr(),
              ),
            CustomNotchedCupertinoListTile(
              leading: Icon(
                CupertinoIcons.eye_slash_fill,
                color: ThemeHelper.cupertinoListTileIconColor(),
              ),
              trailing: CupertinoSwitch(
                value: maskSensitiveInfo,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                    SettingsUpdateMaskSensitiveInfo(value),
                  );
                },
              ),
              titleText: LocaleKeys.mask_senstivie_info_title.tr(),
              subtitleText: LocaleKeys.mask_senstivie_info_subtitle.tr(),
            ),
            CustomNotchedCupertinoListTile(
              leading: FaIcon(
                FontAwesomeIcons.barsStaggered,
                color: ThemeHelper.cupertinoListTileIconColor(),
                size: 23,
              ),
              trailing: CupertinoSwitch(
                value: multiserverActivity,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                    SettingsUpdateMultiserverActivity(value),
                  );
                },
              ),
              titleText: LocaleKeys.multiserver_activity_page_title.tr(),
              subtitleText: LocaleKeys.multiserver_activity_page_subtitle.tr(),
            ),
            CustomNotchedCupertinoListTile(
              leading: Icon(
                CupertinoIcons.arrow_clockwise,
                color: ThemeHelper.cupertinoListTileIconColor(),
              ),
              trailing: CupertinoSwitch(
                value: libraryMediaFullRefresh,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                    SettingsUpdateLibraryMediaFullRefresh(value),
                  );
                },
              ),
              titleText: LocaleKeys.library_media_full_refresh_title.tr(),
              subtitleText: LocaleKeys.library_media_full_refresh_subtitle.tr(),
            ),
            if (appStyle != AppStyle.cupertino)
              CustomNotchedCupertinoListTile(
                leading: Icon(
                  CupertinoIcons.house_fill,
                  color: ThemeHelper.cupertinoListTileIconColor(),
                ),
                trailing: const CupertinoListTileChevron(),
                titleText: LocaleKeys.home_page_title.tr(),
                subtitleText: StringHelper.mapHomePageSettingToTitle(homePageSetting),
                onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) => HomePageIosBottomSheet(
                    initialValue: homePageSetting,
                  ),
                ),
              ),
            CustomNotchedCupertinoListTile(
              leading: FaIcon(
                FontAwesomeIcons.language,
                color: ThemeHelper.cupertinoListTileIconColor(),
                size: 19.2,
              ),
              trailing: const CupertinoListTileChevron(),
              titleText: LocaleKeys.language_title.tr(),
              subtitleText: TranslationHelper.localeToString(context.locale),
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => BlocProvider(
                  create: (context) => di.sl<TranslationBloc>(),
                  child: LanguageIosBottomSheet(initialValue: context.locale),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
