import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../translations/locale_keys.g.dart';
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
            SettingsUpdateRefreshRate(refreshRate: value),
          );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(LocaleKeys.settings_activity_refresh_rate).tr(),
      children: <Widget>[
        RadioListTile(
          title: Text(
              '5 ${LocaleKeys.general_details_sec.tr()} - ${LocaleKeys.settings_faster.tr()}'),
          value: 5,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text(
              '7 ${LocaleKeys.general_details_sec.tr()} - ${LocaleKeys.settings_fast.tr()}'),
          value: 7,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text(
              '10 ${LocaleKeys.general_details_sec.tr()} - ${LocaleKeys.settings_normal.tr()}'),
          value: 10,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text(
              '15 ${LocaleKeys.general_details_sec.tr()} - ${LocaleKeys.settings_slow.tr()}'),
          value: 15,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text(
              '20 ${LocaleKeys.general_details_sec.tr()} - ${LocaleKeys.settings_slower.tr()}'),
          value: 20,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
        RadioListTile(
          title: const Text(LocaleKeys.settings_disabled).tr(),
          value: 0,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value),
        ),
      ],
    );
  }
}
