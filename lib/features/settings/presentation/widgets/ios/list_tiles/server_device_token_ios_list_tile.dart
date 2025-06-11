import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';

class ServerDeviceTokenIosListTile extends StatelessWidget {
  final String deviceToken;

  const ServerDeviceTokenIosListTile({
    super.key,
    required this.deviceToken,
  });

  @override
  Widget build(BuildContext context) {
    return CustomNotchedCupertinoListTile(
      sensitive: true,
      title: const Text(LocaleKeys.device_token_title).tr(),
      subtitle: Text(deviceToken),
      leading: Icon(
        CupertinoIcons.grid_circle_fill,
        color: ThemeHelper.cupertinoListTileIconColor(),
      ),
      onTap: () {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: LocaleKeys.device_token_edit_snackbar_message.tr(),
        );
      },
      onLongPress: () {
        Clipboard.setData(
          ClipboardData(text: deviceToken),
        );
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT,
          msg: LocaleKeys.copied_to_clipboard_snackbar_message.tr(),
        );
      },
    );
  }
}
