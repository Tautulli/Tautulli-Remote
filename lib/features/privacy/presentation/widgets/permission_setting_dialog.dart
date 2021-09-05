// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../translations/locale_keys.g.dart';

Future<void> showPermissionSettingsDialog(
  BuildContext context,
  String title,
  String content,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(LocaleKeys.button_cancel).tr(),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings().then(
                (value) {
                  if (value) {
                    Navigator.of(context).pop();
                  }
                },
              );
            },
            child: const Text(LocaleKeys.button_go_to_settings).tr(),
          ),
        ],
      );
    },
  );
}
