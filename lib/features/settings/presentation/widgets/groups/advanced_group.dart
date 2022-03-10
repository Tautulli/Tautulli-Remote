import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/helpers/translation_helper.dart';
import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../translation/presentation/bloc/translation_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../dialogs/language_dialog.dart';
import '../list_tiles/checkbox_settings_list_tile.dart';

class AdvancedGroup extends StatelessWidget {
  const AdvancedGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: LocaleKeys.settings_title.tr(),
      listTiles: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final doubleBackToExit = state.appSettings.doubleBackToExit;

            return CheckboxSettingsListTile(
              leading: const FaIcon(FontAwesomeIcons.angleDoubleLeft),
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
              leading: const FaIcon(FontAwesomeIcons.solidEyeSlash),
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
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.language),
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
