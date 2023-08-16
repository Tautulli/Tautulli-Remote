import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../active_connection_indicator.dart';
import '../dialogs/server_connection_address_dialog.dart';

class ServerPrimaryConnectionListTile extends StatelessWidget {
  final ServerModel server;

  const ServerPrimaryConnectionListTile({
    super.key,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      sensitive: true,
      leading: FaIcon(
        FontAwesomeIcons.networkWired,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      title: LocaleKeys.primary_connection_title.tr(),
      subtitle: server.primaryConnectionAddress,
      trailing: server.primaryActive == true ? const ActiveConnectionIndicator() : null,
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => ServerConnectionAddressDialog(
            primary: true,
            server: server,
          ),
        );
      },
      onLongPress: () {
        Clipboard.setData(
          ClipboardData(text: server.primaryConnectionAddress),
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              LocaleKeys.copied_to_clipboard_snackbar_message,
            ).tr(),
          ),
        );
      },
    );
  }
}
