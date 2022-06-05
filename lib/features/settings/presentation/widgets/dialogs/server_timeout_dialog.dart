import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';

class ServerTimeoutDialog extends StatefulWidget {
  final int initialValue;

  const ServerTimeoutDialog({
    super.key,
    required this.initialValue,
  });

  @override
  State<ServerTimeoutDialog> createState() => _ServerTimeoutDialogState();
}

class _ServerTimeoutDialogState extends State<ServerTimeoutDialog> {
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
    return SimpleDialog(
      clipBehavior: Clip.hardEdge,
      title: const Text(LocaleKeys.server_timeout_title).tr(),
      children: [
        RadioListTile(
          title: Text('3 ${LocaleKeys.sec.tr()}'),
          value: 3,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: Text('5 ${LocaleKeys.sec.tr()}'),
          value: 5,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: Text('8 ${LocaleKeys.sec.tr()}'),
          value: 8,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: Text(
            '15 ${LocaleKeys.sec.tr()} (${LocaleKeys.default_title.tr()})',
          ),
          value: 15,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value as int),
        ),
        RadioListTile(
          title: Text('30 ${LocaleKeys.sec.tr()}'),
          value: 30,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value as int),
        ),
      ],
    );
  }
}
