import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../translations/locale_keys.g.dart';

Future<void> showNotificationSettingsDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(LocaleKeys.privacy_alert_title).tr(),
        content: const Text(LocaleKeys.privacy_alert_content).tr(),
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
