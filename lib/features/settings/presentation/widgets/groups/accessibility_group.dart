import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';
import '../list_tiles/checkbox_settings_list_tile.dart';

class AccessibilityGroup extends StatelessWidget {
  const AccessibilityGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: LocaleKeys.accessibility_title.tr(),
      listTiles: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final useAtkinsonHyperlegible =
                state.appSettings.useAtkinsonHyperlegible;

            return CheckboxSettingsListTile(
              leading: const FaIcon(FontAwesomeIcons.font),
              title: LocaleKeys.use_atkinson_hyperlegibile_font_title.tr(),
              value: useAtkinsonHyperlegible,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        SettingsUpdateUseAtkinsonHyperlegible(value),
                      );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
