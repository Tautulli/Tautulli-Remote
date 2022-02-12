import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../active_connection_indicator.dart';
import '../dialogs/server_connection_address_dialog.dart';
import '../../../../../core/widgets/custom_list_tile.dart';

class ServerSecondaryConnectionListTile extends StatelessWidget {
  final ServerModel server;

  const ServerSecondaryConnectionListTile({
    Key? key,
    required this.server,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool inactive = isBlank(server.secondaryConnectionAddress);
    return CustomListTile(
      inactive: inactive,
      sensitive: true,
      leading: FaIcon(
        FontAwesomeIcons.networkWired,
        color: inactive ? Theme.of(context).textTheme.subtitle2!.color : null,
      ),
      title: 'Secondary Connection',
      subtitle: inactive ? 'Not configured' : server.secondaryConnectionAddress,
      trailing: server.primaryActive != true
          ? const ActiveConnectionIndicator()
          : null,
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
            ClipboardData(text: server.secondaryConnectionAddress),
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Copied to clipboard'),
            ),
          );
        }
      },
    );
  }
}
