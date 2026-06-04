import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../active_connection_ios_indicator.dart';
import '../bottom_sheets/server_connection_address_ios_bottom_sheet.dart';

class ServerPrimaryConnectionIosListTile extends StatelessWidget {
  final ServerModel server;

  const ServerPrimaryConnectionIosListTile({
    super.key,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    return CustomNotchedCupertinoListTile(
      sensitive: true,
      titleText: LocaleKeys.primary_connection_title.tr(),
      subtitleText: server.primaryConnectionAddress,
      leading: Icon(
        CupertinoIcons.square_fill_line_vertical_square,
        color: ThemeHelper.cupertinoListTileIconColor(),
      ),
      additionalInfo: server.primaryActive == true ? const ActiveConnectionIosIndicator() : null,
      trailing: const CupertinoListTileChevron(),
      onTap: () {
        return showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return ServerConnectionAddressIosBottomSheet(
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
