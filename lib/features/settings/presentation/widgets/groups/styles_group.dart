import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/types/app_style.dart';
import '../../../../../core/widgets/custom_radio_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../bloc/settings_bloc.dart';

class StylesGroup extends StatelessWidget {
  const StylesGroup({super.key});

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
          child: ListTileGroup(
            //TODO:  Create translation key
            heading: 'Styles',
            listTiles: [
              CustomRadioListTile(
                leading: FaIcon(
                  FontAwesomeIcons.android,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                //TODO:  Create translation key
                title: 'Material',
                value: AppStyle.material,
              ),
              CustomRadioListTile(
                leading: FaIcon(
                  FontAwesomeIcons.apple,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                //TODO:  Create translation key
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
