import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/list_tile_group.dart';
import '../pages/server_settings_page.dart';
import 'settings_list_tile.dart';

class ServersGroup extends StatelessWidget {
  const ServersGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      heading: 'Servers',
      settingsListTiles: [
        SettingsListTile(
          leading: WebsafeSvg.asset(
            'assets/logos/logo_flat.svg',
            color: TautulliColorPalette.notWhite,
            height: 35,
          ),
          title: 'Server Name',
          subtitle: 'https://tautulli.domain.com',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ServerSettingsPage(),
            ),
          ),
        ),
      ],
    );
  }
}
