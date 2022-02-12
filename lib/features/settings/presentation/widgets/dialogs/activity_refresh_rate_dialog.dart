import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings_bloc.dart';

class ActivityRefreshRateDialog extends StatefulWidget {
  final int initalValue;

  const ActivityRefreshRateDialog({
    Key? key,
    required this.initalValue,
  }) : super(key: key);

  @override
  State<ActivityRefreshRateDialog> createState() =>
      _ActivityRefreshRateDialogState();
}

class _ActivityRefreshRateDialogState extends State<ActivityRefreshRateDialog> {
  late int _refresh;

  @override
  void initState() {
    super.initState();
    _refresh = widget.initalValue;
  }

  void _refreshRadioValueChanged(int value) {
    setState(() {
      _refresh = value;
      context.read<SettingsBloc>().add(
            SettingsUpdateRefreshRate(value),
          );
      Navigator.of(context).pop();
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
