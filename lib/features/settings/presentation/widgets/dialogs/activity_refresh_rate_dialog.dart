import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';

class ActivityRefreshRateDialog extends StatefulWidget {
  final int initalValue;

  const ActivityRefreshRateDialog({
    super.key,
    required this.initalValue,
  });

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
      clipBehavior: Clip.hardEdge,
      title: const Text(
        LocaleKeys.activity_refresh_rate_title,
      ).tr(),
      children: [
        RadioListTile(
          title: Text(
            '5 ${LocaleKeys.sec.tr()} - ${LocaleKeys.faster_title.tr()}',
          ),
          value: 5,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: Text(
            '7 ${LocaleKeys.sec.tr()} - ${LocaleKeys.fast_title.tr()}',
          ),
          value: 7,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: Text(
            '10 ${LocaleKeys.sec.tr()} - ${LocaleKeys.normal_title.tr()}',
          ),
          value: 10,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: Text(
            '15 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slow_title.tr()}',
          ),
          value: 15,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: Text(
            '20 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slower_title.tr()}',
          ),
          value: 20,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: const Text(LocaleKeys.disabled_title).tr(),
          value: 0,
          groupValue: _refresh,
          onChanged: (value) => _refreshRadioValueChanged(value as int),
        ),
      ],
    );
  }
}
