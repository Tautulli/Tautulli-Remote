import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'checkbox_settings_list_tile.dart';
import 'settings_group.dart';
import 'settings_list_tile.dart';

class AdvancedSettingsGroup extends StatelessWidget {
  const AdvancedSettingsGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      heading: 'Advanced Settings',
      settingsListTiles: [
        CheckboxSettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.backward),
          title: 'Double Tap To Exit',
          subtitle: 'Tap back twice to edit',
          value: false,
          onChanged: (value) {},
        ),
        CheckboxSettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.solidEyeSlash),
          title: 'Mask Sensitive Info',
          subtitle: 'Hides IP addresses and other sensitive info',
          value: false,
          onChanged: (value) {},
        ),
        const SettingsListTile(
          leading: FaIcon(FontAwesomeIcons.language),
          title: 'Language',
          subtitle: 'English',
        ),
      ],
    );
  }
}
