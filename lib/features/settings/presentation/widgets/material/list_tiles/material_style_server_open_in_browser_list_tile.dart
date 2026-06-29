import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/widgets/material/material_style_list_tile_external.dart';
import '../../../../../../translations/locale_keys.g.dart';

class MaterialStyleServerOpenInBrowserListTile extends StatelessWidget {
  final ServerModel server;

  const MaterialStyleServerOpenInBrowserListTile({
    super.key,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return Material(
      color: ElevationOverlay.applySurfaceTint(
        Theme.of(context).colorScheme.surface,
        Theme.of(context).colorScheme.surfaceTint,
        1,
      ),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 35,
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.windowMaximize,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        title: const Text(
          LocaleKeys.open_server_in_browser_title,
        ).tr(args: [server.plexName]),
        trailing: const MaterialStyleListTileExternal(),
        onTap: () async {
          if (server.primaryActive != false) {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              server.primaryConnectionAddress,
            );
          } else if (isNotBlank(server.secondaryConnectionAddress)) {
            await launchUrlString(
              mode: LaunchMode.externalApplication,
              server.secondaryConnectionAddress!,
            );
          }
        },
        onLongPress: () async {
          // If a secondary connection address is configured launchUrlString the non active address on a long press
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
      ),
    );
  }
}
