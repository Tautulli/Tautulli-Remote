import 'package:flutter/material.dart';

class ActivityRefreshRateDialog extends StatefulWidget {
  const ActivityRefreshRateDialog({Key? key}) : super(key: key);

  @override
  State<ActivityRefreshRateDialog> createState() =>
      _ActivityRefreshRateDialogState();
}

class _ActivityRefreshRateDialogState extends State<ActivityRefreshRateDialog> {
  late int _refresh = 0;

  void _refreshRadioValueChanged(int value) {
    setState(() {
      _refresh = value;

      // Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        'Activity Refresh Rate',
      ),
      children: [
        RadioListTile(
          title: const Text('5 sec - Faster'),
          value: 5,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: const Text('7 sec - Fast'),
          value: 7,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: const Text('10 sec - Normal'),
          value: 10,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: const Text('15 sec - Slow'),
          value: 15,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: const Text('20 sec - Slower'),
          value: 20,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: const Text('Disabled'),
          value: 0,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
      ],
    );
  }
}
