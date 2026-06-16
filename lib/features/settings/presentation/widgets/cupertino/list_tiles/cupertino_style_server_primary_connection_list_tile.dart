import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../cupertino_style_active_connection_indicator.dart';
import '../bottom_sheets/cupertino_style_server_connection_address_bottom_sheet.dart';

class CupertinoStyleServerPrimaryConnectionListTile extends StatelessWidget {
  final ServerModel server;

  const CupertinoStyleServerPrimaryConnectionListTile({
    super.key,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleNotchedCupertinoListTile(
      sensitive: true,
      titleText: LocaleKeys.primary_connection_title.tr(),
      subtitleText: server.primaryConnectionAddress,
      leading: const Icon(
        CupertinoIcons.square_fill_line_vertical_square,
        color: ThemeHelper.cupertinoListTileIconColor,
      ),
      additionalInfo: server.primaryActive == true ? const CupertinoStyleActiveConnectionIndicator() : null,
      trailing: const CupertinoListTileChevron(),
      onTap: () {
        return showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoStyleServerConnectionAddressBottomSheet(
              primary: true,
              server: server,
              title: LocaleKeys.primary_connection_title.tr(),
            );
          },
        );
      },
      onLongPress: () {
        Clipboard.setData(
          ClipboardData(text: server.primaryConnectionAddress),
        );
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT,
          msg: LocaleKeys.copied_to_clipboard_snackbar_message.tr(),
        );
      },
    );
  }
}
