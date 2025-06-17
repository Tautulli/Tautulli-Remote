import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/types/framework.dart';
import '../../../../../core/widgets/custom_radio_list_tile.dart';
import '../../../../../core/widgets/list_tile_group.dart';
import '../../bloc/settings_bloc.dart';

class FrameworkGroup extends StatelessWidget {
  const FrameworkGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        state as SettingsSuccess;

        return ListTileGroup(
          //TODO:  Create translation key
          heading: 'Framework',
          listTiles: [
            CustomRadioListTile(
              leading: FaIcon(
                FontAwesomeIcons.android,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              //TODO:  Create translation key
              title: 'Android',
              value: Framework.android,
              groupValue: state.appSettings.framework,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                      SettingsUpdateFramework(value as Framework),
                    );
              },
            ),
            CustomRadioListTile(
              leading: FaIcon(
                FontAwesomeIcons.apple,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              //TODO:  Create translation key
              title: 'iOS',
              value: Framework.ios,
              groupValue: state.appSettings.framework,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                      SettingsUpdateFramework(value as Framework),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}
