import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../translations/locale_keys.g.dart';

class PermissionSettingDialog extends StatelessWidget {
  final String title;
  final String content;

  const PermissionSettingDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.cancel_title).tr(),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
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
