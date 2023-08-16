import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../active_connection_indicator.dart';
import '../dialogs/server_connection_address_dialog.dart';

class ServerSecondaryConnectionListTile extends StatelessWidget {
  final ServerModel server;

  const ServerSecondaryConnectionListTile({
    super.key,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    final bool inactive = isBlank(server.secondaryConnectionAddress);
    return CustomListTile(
      inactive: inactive,
      sensitive: true,
      leading: FaIcon(
        FontAwesomeIcons.networkWired,
        color: inactive ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.onSurface,
      ),
      title: LocaleKeys.secondary_connection_title.tr(),
      subtitle: inactive ? LocaleKeys.not_configured_message.tr() : server.secondaryConnectionAddress,
      trailing: server.primaryActive != true ? const ActiveConnectionIndicator() : null,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ServerConnectionAddressDialog(
            primary: false,
            server: server,
          ),
        );
      },
      onLongPress: () {
        if (!inactive) {
          Clipboard.setData(
            ClipboardData(text: server.secondaryConnectionAddress!),
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                LocaleKeys.copied_to_clipboard_snackbar_message,
              ).tr(),
            ),
          );
        }
      },
    );
  }
}
