import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../../core/widgets/material/material_style_list_tile_chevron.dart';
import '../../../../../../core/widgets/material/material_style_list_tile_group.dart';
import '../../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../../translations/locale_keys.g.dart';
import 'material_style_logging_page.dart';
import 'material_style_notification_logs_page.dart';

class MaterialStyleLogsPage extends StatelessWidget {
  const MaterialStyleLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.logs_title).tr(),
      ),
      body: MaterialStylePageBody(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            MaterialStyleListTileGroup(
              heading: LocaleKeys.device_logs_title.tr(),
              listTiles: [
                MaterialStyleListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.mobileScreen,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: LocaleKeys.app_logs_title.tr(),
                  trailing: const MaterialStyleListTileChevron(),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MaterialStyleLoggingPage(),
                      ),
                    );
                  },
                ),
                MaterialStyleListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.solidBell,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: LocaleKeys.notification_logs_title.tr(),
                  trailing: const MaterialStyleListTileChevron(),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MaterialStyleNotificationLogsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
