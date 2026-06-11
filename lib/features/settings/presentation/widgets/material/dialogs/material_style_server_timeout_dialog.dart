import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class MaterialStyleServerTimeoutDialog extends StatefulWidget {
  final int initialValue;

  const MaterialStyleServerTimeoutDialog({
    super.key,
    required this.initialValue,
  });

  @override
  State<MaterialStyleServerTimeoutDialog> createState() => _ServerTimeoutDialogState();
}

class _ServerTimeoutDialogState extends State<MaterialStyleServerTimeoutDialog> {
  late int _timeout;

  @override
  void initState() {
    super.initState();
    _timeout = widget.initialValue;
  }

  void _timeoutRadioValueChanged(int value) {
    setState(() {
      _timeout = value;
      context.read<SettingsBloc>().add(
        SettingsUpdateServerTimeout(value),
      );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RadioGroup<int>(
      groupValue: _timeout,
      onChanged: (value) {
        if (value != null) {
          _timeoutRadioValueChanged(value);
        }
      },
      child: SimpleDialog(
        clipBehavior: Clip.hardEdge,
        title: const Text(LocaleKeys.server_timeout_title).tr(),
        children: [
          RadioListTile(
            title: Text('3 ${LocaleKeys.sec.tr()}'),
            value: 3,
          ),
          RadioListTile(
            title: Text('5 ${LocaleKeys.sec.tr()}'),
            value: 5,
          ),
          RadioListTile(
            title: Text('8 ${LocaleKeys.sec.tr()}'),
            value: 8,
          ),
          RadioListTile(
            title: Text(
              '15 ${LocaleKeys.sec.tr()} (${LocaleKeys.default_title.tr()})',
            ),
            value: 15,
          ),
          RadioListTile(
            title: Text('30 ${LocaleKeys.sec.tr()}'),
            value: 30,
          ),
        ],
      ),
    );
  }
}
