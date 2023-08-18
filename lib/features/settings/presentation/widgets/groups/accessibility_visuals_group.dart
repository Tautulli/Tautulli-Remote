import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/widgets/list_tile_group.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';
import '../list_tiles/checkbox_settings_list_tile.dart';

class AccessibilityVisualsGroup extends StatelessWidget {
  const AccessibilityVisualsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: LocaleKeys.visuals_title.tr(),
      listTiles: [
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return CheckboxSettingsListTile(
              value: state.appSettings.disableImageBackgrounds,
              leading: FaIcon(
                FontAwesomeIcons.image,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: LocaleKeys.disable_image_backgrounds_title.tr(),
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        SettingsUpdateDisableImageBackgrounds(value),
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
