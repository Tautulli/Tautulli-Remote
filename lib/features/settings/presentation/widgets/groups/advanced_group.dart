import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/helpers/translation_helper.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../translation/presentation/bloc/translation_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../dialogs/language_dialog.dart';
import '../list_tiles/checkbox_settings_list_tile.dart';
import '../../../../../core/widgets/custom_list_tile.dart';

class AdvancedGroup extends StatelessWidget {
  const AdvancedGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: 'Settings',
      listTiles: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final doubleTapToExit = state.appSettings.doubleTapToExit;

            return CheckboxSettingsListTile(
              leading: const FaIcon(FontAwesomeIcons.angleDoubleLeft),
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
              subtitleIsTwoLines: true,
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
        CustomListTile(
          leading: const FaIcon(FontAwesomeIcons.language),
          title: 'Language',
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