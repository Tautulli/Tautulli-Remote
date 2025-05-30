import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class ServerTimeoutActionSheet extends StatefulWidget {
  final int initialValue;

  const ServerTimeoutActionSheet({
    super.key,
    required this.initialValue,
  });

  @override
  State<ServerTimeoutActionSheet> createState() => _ServerTimeoutActionSheetState();
}

class _ServerTimeoutActionSheetState extends State<ServerTimeoutActionSheet> {
  late int _timeout;

  @override
  void initState() {
    super.initState();
    _timeout = widget.initialValue;
  }

  void _timeoutValueChanged(int value) {
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
    return CupertinoActionSheet(
      title: const Text(LocaleKeys.server_timeout_title).tr(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: _timeout == 3,
          onPressed: () {
            _timeoutValueChanged(3);
          },
          child: Text(
            '3 ${LocaleKeys.sec.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _timeout == 5,
          onPressed: () {
            _timeoutValueChanged(5);
          },
          child: Text(
            '5 ${LocaleKeys.sec.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _timeout == 8,
          onPressed: () {
            _timeoutValueChanged(8);
          },
          child: Text(
            '8 ${LocaleKeys.sec.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _timeout == 15,
          onPressed: () {
            _timeoutValueChanged(15);
          },
          child: Text(
            '15 ${LocaleKeys.sec.tr()} (${LocaleKeys.default_title.tr()})',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: _timeout == 30,
          onPressed: () {
            _timeoutValueChanged(30);
          },
          child: Text(
            '30 ${LocaleKeys.sec.tr()}',
          ),
        ),
      ],
    );
  }
}
