import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../active_connection_indicator.dart';
import '../dialogs/server_connection_address_dialog.dart';
import '../../../../../core/widgets/custom_list_tile.dart';

class ServerPrimaryConnectionListTile extends StatelessWidget {
  final ServerModel server;

  const ServerPrimaryConnectionListTile({
    Key? key,
    required this.server,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      sensitive: true,
      leading: const FaIcon(FontAwesomeIcons.networkWired),
      title: 'Primary Connection',
      subtitle: server.primaryConnectionAddress,
      trailing: server.primaryActive == true
          ? const ActiveConnectionIndicator()
          : null,
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
          const SnackBar(
            content: Text('Copied to clipboard'),
          ),
        );
      },
    );
  }
}
