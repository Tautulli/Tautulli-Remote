import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';
import '../list_tiles/checkbox_settings_list_tile.dart';

class AccessibilityFontGroup extends StatelessWidget {
  const AccessibilityFontGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: LocaleKeys.font_title.tr(),
      listTiles: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;
            final useAtkinsonHyperlegible = state.appSettings.useAtkinsonHyperlegible;

            return CheckboxSettingsListTile(
              leading: FaIcon(
                FontAwesomeIcons.font,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: 'Atkinson Hyperlegible',
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
