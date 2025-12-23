import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/ios/cupertino_list_tile_external.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';

class ServerOpenInBrowserIosListTile extends StatelessWidget {
  final ServerModel server;

  const ServerOpenInBrowserIosListTile({
    super.key,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    return CustomNotchedCupertinoListTile(
      titleText: LocaleKeys.open_server_in_browser_title.tr(args: [server.plexName]),
      leading: Icon(
        CupertinoIcons.macwindow,
        color: ThemeHelper.cupertinoListTileIconColor(),
      ),
      trailing: const CupertinoListTileExternal(),
      onTap: () async {
        if (server.primaryActive != false) {
          await launchUrlString(
            mode: LaunchMode.externalApplication,
            server.primaryConnectionAddress,
          );
        } else if (server.secondaryConnectionAddress != null) {
          await launchUrlString(
            mode: LaunchMode.externalApplication,
            server.secondaryConnectionAddress!,
          );
        }
      },
      onLongPress: () async {
        // If a secondary connection address is configured launchUrlString
        // the non active address on a long press
        //TODO: Update android to also use isNotBlank
        if (isNotBlank(server.secondaryConnectionAddress)) {
          if (server.primaryActive != false) {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              server.secondaryConnectionAddress!,
            );
          } else {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              server.primaryConnectionAddress,
            );
          }
        }
      },
    );
  }
}
