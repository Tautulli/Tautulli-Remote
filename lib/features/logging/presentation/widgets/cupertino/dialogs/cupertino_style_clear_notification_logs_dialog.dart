import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/notification_logs_bloc.dart';

class CupertinoStyleClearNotificationLogsDialog extends StatelessWidget {
  const CupertinoStyleClearNotificationLogsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoAlertDialog(
      title: const Text(LocaleKeys.notification_logs_clear_dialog_title).tr(),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(LocaleKeys.cancel_title).tr(),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            context.read<NotificationLogsBloc>().add(NotificationLogsClear());
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.clear_title).tr(),
        ),
      ],
    );
  }
}
