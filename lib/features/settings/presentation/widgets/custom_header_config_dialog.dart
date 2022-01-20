import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum CustomHeaderType {
  basicAuth,
  custom,
}

class CustomHeaderConfigDialog extends StatelessWidget {
  final CustomHeaderType headerType;

  const CustomHeaderConfigDialog({
    Key? key,
    required this.headerType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 6.0),
      title: Row(
        children: [
          FaIcon(
            headerType == CustomHeaderType.basicAuth
                ? FontAwesomeIcons.solidAddressCard
                : FontAwesomeIcons.addressCard,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              headerType == CustomHeaderType.basicAuth
                  ? 'Basic Authentication'
                  : 'Custom',
            ),
          ),
        ],
      ),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: headerType == CustomHeaderType.basicAuth
                    ? 'Username'
                    : 'Header Key',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: headerType == CustomHeaderType.basicAuth
                    ? 'Password'
                    : 'Header Value',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('SAVE'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
