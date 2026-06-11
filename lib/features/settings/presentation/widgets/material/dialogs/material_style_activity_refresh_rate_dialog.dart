import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class MaterialStyleActivityRefreshRateDialog extends StatefulWidget {
  final int initalValue;

  const MaterialStyleActivityRefreshRateDialog({
    super.key,
    required this.initalValue,
  });

  @override
  State<MaterialStyleActivityRefreshRateDialog> createState() => _ActivityRefreshRateDialogState();
}

class _ActivityRefreshRateDialogState extends State<MaterialStyleActivityRefreshRateDialog> {
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
    return RadioGroup<int>(
      groupValue: _refresh,
      onChanged: (value) {
        if (value != null) {
          _refreshRadioValueChanged(value);
        }
      },
      child: SimpleDialog(
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
          ),
          RadioListTile(
            title: Text(
              '7 ${LocaleKeys.sec.tr()} - ${LocaleKeys.fast_title.tr()}',
            ),
            value: 7,
          ),
          RadioListTile(
            title: Text(
              '10 ${LocaleKeys.sec.tr()} - ${LocaleKeys.normal_title.tr()}',
            ),
            value: 10,
          ),
          RadioListTile(
            title: Text(
              '15 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slow_title.tr()}',
            ),
            value: 15,
          ),
          RadioListTile(
            title: Text(
              '20 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slower_title.tr()}',
            ),
            value: 20,
          ),
          RadioListTile(
            title: const Text(LocaleKeys.disabled_title).tr(),
            value: 0,
          ),
        ],
      ),
    );
  }
}
