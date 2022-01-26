import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/list_tile_group.dart';
import 'clear_cache_dialog.dart';
import 'settings_list_tile.dart';

class OperationsGroup extends StatelessWidget {
  const OperationsGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: 'Operations',
      settingsListTiles: [
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.eraser),
          title: 'Clear Image Cache',
          subtitle: 'Delete cached posters and artwork',
          onTap: () async {
            final bool cleared = await showDialog(
              context: context,
              builder: (context) => const ClearCacheDialog(),
            );

            if (cleared) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image cache cleared.'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
