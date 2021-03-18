import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';

class ActivityRefreshRateDialog extends StatefulWidget {
  final int initialValue;

  ActivityRefreshRateDialog({
    Key key,
    @required this.initialValue,
  }) : super(key: key);

  @override
  _ActivityRefreshRateDialogState createState() =>
      _ActivityRefreshRateDialogState();
}

class _ActivityRefreshRateDialogState extends State<ActivityRefreshRateDialog> {
  int _refresh;

  @override
  void initState() {
    super.initState();
    _refresh = widget.initialValue;
  }

  void _refreshRadioValueChanged(int value) {
    setState(() {
      _refresh = value;
      context.read<SettingsBloc>().add(
            SettingsUpdateRefreshRate(refreshRate: value == 0 ? null : value),
          );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Activity Refresh Rate'),
      children: <Widget>[
        RadioListTile(
          title: Text('5 sec - Faster'),
          value: 5,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text('7 sec - Fast'),
          value: 7,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text('10 sec - Normal'),
          value: 10,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text('15 sec - Slow'),
          value: 15,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text('20 sec - Slower'),
          value: 20,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text('Disabled'),
          value: 0,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
      ],
    );
  }
}
