import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionSettingDialog extends StatelessWidget {
  final String title;
  final String content;

  const PermissionSettingDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
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
  }
}
