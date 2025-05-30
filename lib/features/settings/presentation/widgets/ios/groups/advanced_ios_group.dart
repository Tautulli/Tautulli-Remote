import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/device_info/device_info.dart';
import '../../../../../../core/helpers/string_helper.dart';
import '../../../../../../core/helpers/translation_helper.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../dependency_injection.dart' as di;
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../translation/presentation/bloc/translation_bloc.dart';
import '../../../bloc/settings_bloc.dart';
import '../action_sheets/home_page_action_sheet.dart';
import '../action_sheets/language_action_sheet.dart';

class AdvancedIosGroup extends StatelessWidget {
  const AdvancedIosGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: LocaleKeys.settings_title.tr(),
      children: [
        if (di.sl<DeviceInfo>().platform == 'android')
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;
              final doubleBackToExit = state.appSettings.doubleBackToExit;

              return CupertinoListTile.notched(
                leading: const FaIcon(FontAwesomeIcons.anglesLeft),
                trailing: CupertinoSwitch(
                  value: doubleBackToExit,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(
                          SettingsUpdateDoubleBackToExit(value),
                        );
                  },
                ),
                title: const Text(LocaleKeys.double_back_to_exit_title).tr(),
                subtitle: const Text(LocaleKeys.double_back_to_exit_subtitle).tr(),
              );
            },
          ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final maskSensitiveInfo = state.appSettings.maskSensitiveInfo;

            return CupertinoListTile.notched(
              leading: const FaIcon(FontAwesomeIcons.solidEyeSlash),
              trailing: CupertinoSwitch(
                value: maskSensitiveInfo,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        SettingsUpdateMaskSensitiveInfo(value),
                      );
                },
              ),
              title: const Text(LocaleKeys.mask_senstivie_info_title).tr(),
              subtitle: const Text(LocaleKeys.mask_senstivie_info_subtitle).tr(),
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final multiserverActivity = state.appSettings.multiserverActivity;

            return CupertinoListTile.notched(
              leading: const FaIcon(FontAwesomeIcons.barsStaggered),
              trailing: CupertinoSwitch(
                value: multiserverActivity,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        SettingsUpdateMultiserverActivity(value),
                      );
                },
              ),
              title: const Text(LocaleKeys.multiserver_activity_page_title).tr(),
              subtitle: const Text(LocaleKeys.multiserver_activity_page_subtitle).tr(),
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final libraryMediaFullRefresh = state.appSettings.libraryMediaFullRefresh;

            return CupertinoListTile.notched(
              leading: const FaIcon(FontAwesomeIcons.arrowRotateRight),
              trailing: CupertinoSwitch(
                value: libraryMediaFullRefresh,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        SettingsUpdateLibraryMediaFullRefresh(value),
                      );
                },
              ),
              title: const Text(LocaleKeys.library_media_full_refresh_title).tr(),
              subtitle: const Text(LocaleKeys.library_media_full_refresh_subtitle).tr(),
            );
          },
        ),
        //TODO: Hide if using Cupertino framework
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final homePageSetting = state.appSettings.homePage;

            return CupertinoListTile.notched(
              leading: const FaIcon(FontAwesomeIcons.house),
              trailing: const CupertinoListTileChevron(),
              title: const Text(LocaleKeys.home_page_title).tr(),
              subtitle: Text(StringHelper.mapHomePageSettingToTitle(homePageSetting)),
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => HomePageActionSheet(initialValue: homePageSetting),
              ),
            );
          },
        ),
        CupertinoListTile.notched(
          leading: const FaIcon(FontAwesomeIcons.language),
          trailing: const CupertinoListTileChevron(),
          title: const Text(LocaleKeys.language_title).tr(),
          subtitle: Text(TranslationHelper.localeToString(context.locale)),
          onTap: () => showCupertinoModalPopup(
            context: context,
            builder: (context) => BlocProvider(create: (context) => di.sl<TranslationBloc>(), child: LanguageActionSheet(initialValue: context.locale)),
          ),
        ),
      ],
    );
  }
}
