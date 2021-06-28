import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../translations/locale_keys.g.dart';
import '../bloc/settings_bloc.dart';

class ServerTimeoutDialog extends StatefulWidget {
  final int initialValue;

  ServerTimeoutDialog({
    Key key,
    @required this.initialValue,
  }) : super(key: key);

  @override
  _ServerTimeoutDialogState createState() => _ServerTimeoutDialogState();
}

class _ServerTimeoutDialogState extends State<ServerTimeoutDialog> {
  int _timeout;

  @override
  void initState() {
    super.initState();
    _timeout = widget.initialValue;
  }

  void _timeoutRadioValueChanged(int value) {
    setState(() {
      _timeout = value;
      context
          .read<SettingsBloc>()
          .add(SettingsUpdateServerTimeout(timeout: value));
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(LocaleKeys.settings_server_timeout).tr(),
      children: <Widget>[
        RadioListTile(
          title: Text('3 ${LocaleKeys.general_details_sec.tr()}'),
          value: 3,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text('5 ${LocaleKeys.general_details_sec.tr()}'),
          value: 5,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text('8 ${LocaleKeys.general_details_sec.tr()}'),
          value: 8,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text(
            '15 ${LocaleKeys.general_details_sec.tr()} (${LocaleKeys.settings_default.tr()})',
          ),
          value: 15,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value),
        ),
        RadioListTile(
          title: Text('30 ${LocaleKeys.general_details_sec.tr()}'),
          value: 30,
          groupValue: _timeout,
          onChanged: (value) => _timeoutRadioValueChanged(value),
        ),
      ],
    );
  }
}
