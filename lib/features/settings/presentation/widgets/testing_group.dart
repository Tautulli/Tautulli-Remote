import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/list_tile_group.dart';
import '../pages/data_dump.dart';
import '../pages/how_to_test_page.dart';
import 'settings_list_tile.dart';

class TestingGroup extends StatelessWidget {
  const TestingGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: 'Testing',
      listTiles: [
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.handsHelping),
          title: 'How To Test',
          subtitle: 'Help make v3 the best version of itself',
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const HowToTestPage(),
              ),
            );
          },
        ),
        SettingsListTile(
          leading: const FaIcon(FontAwesomeIcons.faucet),
          title: 'Data Dump',
          subtitle: 'App status and settings',
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const DataDumpPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
