import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';

class MaterialStyleServerDeviceTokenListTile extends StatelessWidget {
  final String deviceToken;

  const MaterialStyleServerDeviceTokenListTile({
    super.key,
    required this.deviceToken,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return MaterialStyleListTile(
      sensitive: true,
      leading: FaIcon(
        FontAwesomeIcons.key,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: LocaleKeys.device_token_title.tr(),
      subtitle: deviceToken,
      inactive: true,
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(LocaleKeys.device_token_edit_snackbar_message).tr(),
            action: SnackBarAction(
              label: LocaleKeys.learn_more_title.tr(),
              onPressed: () async {
                await launchUrlString(
                  mode: LaunchMode.externalApplication,
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
