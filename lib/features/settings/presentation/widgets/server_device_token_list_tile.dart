import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings_list_tile.dart';

class ServerDeviceTokenListTile extends StatelessWidget {
  final String deviceToken;

  const ServerDeviceTokenListTile({
    Key? key,
    required this.deviceToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      sensitive: true,
      leading: FaIcon(
        FontAwesomeIcons.key,
        color: Theme.of(context).textTheme.subtitle2!.color,
      ),
      title: 'Device Token',
      subtitle: deviceToken,
      disabled: true,
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Device tokens cannot be edited'),
            action: SnackBarAction(
              label: 'LEARN MORE',
              onPressed: () async {
                await launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Settings#device_tokens',
                );
              },
            ),
          ),
        );
      },
      onLongPress: () {
        Clipboard.setData(
          ClipboardData(text: deviceToken),
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
