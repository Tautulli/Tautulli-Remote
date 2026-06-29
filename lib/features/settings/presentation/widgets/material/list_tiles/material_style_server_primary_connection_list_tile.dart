import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../material_style_active_connection_indicator.dart';
import '../bottom_sheets/material_style_server_connection_address_bottom_sheet.dart';

class MaterialStyleServerPrimaryConnectionListTile extends StatelessWidget {
  final ServerModel server;

  const MaterialStyleServerPrimaryConnectionListTile({
    super.key,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return MaterialStyleListTile(
      sensitive: true,
      leading: FaIcon(
        FontAwesomeIcons.networkWired,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      title: LocaleKeys.primary_connection_title.tr(),
      subtitle: server.primaryConnectionAddress,
      trailing: server.primaryActive == true ? const MaterialStyleActiveConnectionIndicator() : null,
      onTap: () async {
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => MaterialStyleServerConnectionAddressBottomSheet(
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
