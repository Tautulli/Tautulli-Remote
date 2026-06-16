import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiver/strings.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../cupertino_style_active_connection_indicator.dart';
import '../bottom_sheets/cupertino_style_server_connection_address_bottom_sheet.dart';

class CupertinoStyleServerSecondaryConnectionListTile extends StatelessWidget {
  final ServerModel server;

  const CupertinoStyleServerSecondaryConnectionListTile({
    super.key,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    final bool inactive = isBlank(server.secondaryConnectionAddress);

    return CupertinoStyleNotchedCupertinoListTile(
      sensitive: true,
      titleText: LocaleKeys.secondary_connection_title.tr(),
      subtitleText: inactive ? LocaleKeys.not_configured_message.tr() : server.secondaryConnectionAddress!,
      leading: const Icon(
        CupertinoIcons.square_line_vertical_square_fill,
        color: ThemeHelper.cupertinoListTileIconColor,
      ),
      additionalInfo: server.primaryActive != true ? const CupertinoStyleActiveConnectionIndicator() : null,
      trailing: const CupertinoListTileChevron(),
      onTap: () {
        return showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoStyleServerConnectionAddressBottomSheet(
              primary: false,
              server: server,
              title: LocaleKeys.secondary_connection_title.tr(),
            );
          },
        );
      },
      onLongPress: () {
        if (!inactive) {
          Clipboard.setData(
            ClipboardData(text: server.secondaryConnectionAddress!),
          );
          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            msg: LocaleKeys.copied_to_clipboard_snackbar_message.tr(),
          );
        }
      },
    );
  }
}
