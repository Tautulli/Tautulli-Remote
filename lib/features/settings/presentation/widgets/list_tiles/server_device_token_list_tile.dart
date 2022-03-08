import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/widgets/custom_list_tile.dart';
import '../../../../../translations/locale_keys.g.dart';

class ServerDeviceTokenListTile extends StatelessWidget {
  final String deviceToken;

  const ServerDeviceTokenListTile({
    Key? key,
    required this.deviceToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      sensitive: true,
      leading: FaIcon(
        FontAwesomeIcons.key,
        color: Theme.of(context).textTheme.subtitle2!.color,
      ),
      title: LocaleKeys.device_token_title.tr(),
      subtitle: deviceToken,
      inactive: true,
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              LocaleKeys.device_token_edit_snackbar_message,
            ).tr(),
            action: SnackBarAction(
              label: LocaleKeys.learn_more_button.tr(),
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
