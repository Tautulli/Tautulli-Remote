import 'package:flutter/material.dart';

class ServerTimeoutDialog extends StatefulWidget {
  const ServerTimeoutDialog({Key? key}) : super(key: key);

  @override
  State<ServerTimeoutDialog> createState() => _ServerTimeoutDialogState();
}

class _ServerTimeoutDialogState extends State<ServerTimeoutDialog> {
  late int _timeout = 15;

  void _timeoutRadioValueChanged(int value) {
    setState(() {
      _timeout = value;
      // Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Server Timeout'),
      children: [
        RadioListTile(
          title: const Text('3 sec'),
          value: 3,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: const Text('5 sec'),
          value: 5,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: const Text('8 sec'),
          value: 8,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: const Text('15 sec (Default)'),
          value: 15,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: const Text('30 sec'),
          value: 30,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value as int),
        ),
      ],
    );
  }
}
