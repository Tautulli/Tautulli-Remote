import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../translations/locale_keys.g.dart';

class PermissionSettingIosDialog extends StatelessWidget {
  final String title;
  final String content;

  const PermissionSettingIosDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(LocaleKeys.cancel_title).tr(),
        ),
        CupertinoDialogAction(
          onPressed: () async {
            await openAppSettings().then(
              (value) {
                if (value) {
                  Navigator.of(context).pop();
                }
              },
            );
          },
          child: const Text(LocaleKeys.go_to_settings_title).tr(),
        ),
      ],
    );
  }
}
