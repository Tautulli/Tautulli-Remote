import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tautulli_remote/features/settings/presentation/widgets/language_dialog.dart';
import 'package:tautulli_remote/features/translation/presentation/bloc/translation_bloc.dart';

import '../../../../core/helpers/translation_helper.dart';
import '../bloc/settings_bloc.dart';
import 'checkbox_settings_list_tile.dart';
import 'settings_group.dart';
import 'settings_list_tile.dart';

class AdvancedGroup extends StatelessWidget {
  const AdvancedGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      heading: 'Settings',
      settingsListTiles: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final doubleTapToExit = state.appSettings.doubleTapToExit;

            return CheckboxSettingsListTile(
              leading: const FaIcon(FontAwesomeIcons.backward),
              title: 'Double Tap To Exit',
              subtitle: 'Tap back twice to edit',
              value: doubleTapToExit,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        SettingsUpdateDoubleTapToExit(value),
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
              leading: const FaIcon(FontAwesomeIcons.solidEyeSlash),
              title: 'Mask Sensitive Info',
              subtitle: 'Hides IP addresses and other sensitive info',
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
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.language),
          title: 'Language',
          subtitle: TranslationHelper.localeToString(context.locale),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => TranslationBloc(),
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
