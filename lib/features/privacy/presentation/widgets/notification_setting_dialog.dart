import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> showNotificationSettingsDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Notification Permission Required'),
        content: const Text(
          'Give Tautulli Remote notification access to receive push notitifications.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('CANCEL'),
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
            child: const Text('GO TO SETTINGS'),
          ),
        ],
      );
    },
  );
}
