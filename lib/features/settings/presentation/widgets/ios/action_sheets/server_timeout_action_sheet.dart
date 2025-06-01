import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class ServerTimeoutActionSheet extends StatelessWidget {
  final int initialValue;

  const ServerTimeoutActionSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    void timeoutValueChanged(int value) {
      context.read<SettingsBloc>().add(
            SettingsUpdateServerTimeout(value),
          );
      Navigator.of(context).pop();
    }

    return CupertinoActionSheet(
      title: const Text(LocaleKeys.server_timeout_title).tr(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 3,
          onPressed: () {
            timeoutValueChanged(3);
          },
          child: Text(
            '3 ${LocaleKeys.sec.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 5,
          onPressed: () {
            timeoutValueChanged(5);
          },
          child: Text(
            '5 ${LocaleKeys.sec.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 8,
          onPressed: () {
            timeoutValueChanged(8);
          },
          child: Text(
            '8 ${LocaleKeys.sec.tr()}',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 15,
          onPressed: () {
            timeoutValueChanged(15);
          },
          child: Text(
            '15 ${LocaleKeys.sec.tr()} (${LocaleKeys.default_title.tr()})',
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == 30,
          onPressed: () {
            timeoutValueChanged(30);
          },
          child: Text(
            '30 ${LocaleKeys.sec.tr()}',
          ),
        ),
      ],
    );
  }
}
