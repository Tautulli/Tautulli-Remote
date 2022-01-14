import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'settings_group.dart';
import 'settings_list_tile.dart';

class OperationsGroup extends StatelessWidget {
  const OperationsGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsGroup(
      heading: 'Operations',
      settingsListTiles: [
        SettingsListTile(
          leading: FaIcon(FontAwesomeIcons.eraser),
          title: 'Clear Image Cache',
          subtitle: 'Delete cached posters and artwork',
        ),
      ],
    );
  }
}
