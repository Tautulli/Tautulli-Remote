import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import 'settings_group.dart';
import 'settings_list_tile.dart';

class ServersGroup extends StatelessWidget {
  const ServersGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      heading: 'Servers',
      settingsListTiles: [
        SettingsListTile(
          leading: SizedBox(
            width: 35,
            height: 35,
            child: WebsafeSvg.asset(
              'assets/logo/logo_flat.svg',
              color: TautulliColorPalette.notWhite,
            ),
          ),
          title: 'Server Name',
          subtitle: 'https://tautulli.domain.com',
          onTap: () {},
        ),
      ],
    );
  }
}
