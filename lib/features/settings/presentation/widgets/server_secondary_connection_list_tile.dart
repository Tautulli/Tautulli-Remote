import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';

import '../../../../core/database/data/models/server_model.dart';
import 'active_connection_indicator.dart';
import 'server_connection_address_dialog.dart';
import 'settings_list_tile.dart';

class ServerSecondaryConnectionListTile extends StatelessWidget {
  final ServerModel server;

  const ServerSecondaryConnectionListTile({
    Key? key,
    required this.server,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool disabled = isBlank(server.secondaryConnectionAddress);
    return SettingsListTile(
      disabled: disabled,
      sensitive: true,
      leading: FaIcon(
        FontAwesomeIcons.networkWired,
        color: disabled ? Theme.of(context).textTheme.subtitle2!.color : null,
      ),
      title: 'Secondary Connection',
      subtitle: disabled ? 'Not configured' : server.secondaryConnectionAddress,
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
        if (!disabled) {
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
