import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/types/app_style.dart';
import '../../../../../../core/widgets/material/material_style_radio_list_tile.dart';
import '../../../../../../core/widgets/material/material_style_list_tile_group.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class MaterialStyleStylesGroup extends StatelessWidget {
  const MaterialStyleStylesGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        return RadioGroup<AppStyle>(
          groupValue: state.appSettings.appStyle,
          onChanged: (value) {
            if (value != null) {
              context.read<SettingsBloc>().add(
                SettingsUpdateAppStyle(value),
              );
            }
          },
          child: MaterialStyleListTileGroup(
            heading: LocaleKeys.styles_title.tr(),
            listTiles: [
              MaterialStyleRadioListTile(
                leading: FaIcon(
                  FontAwesomeIcons.android,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: 'Material',
                value: AppStyle.material,
              ),
              MaterialStyleRadioListTile(
                leading: FaIcon(
                  FontAwesomeIcons.apple,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: 'Cupertino',
                value: AppStyle.cupertino,
              ),
            ],
          ),
        );
      },
    );
  }
}
