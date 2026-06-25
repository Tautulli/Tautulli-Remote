import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/notification_logs_bloc.dart';

class MaterialStyleClearNotificationLogsDialog extends StatelessWidget {
  const MaterialStyleClearNotificationLogsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.notification_logs_clear_dialog_title).tr(),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.cancel_title).tr(),
        ),
        TextButton(
          onPressed: () {
            context.read<NotificationLogsBloc>().add(NotificationLogsClear());
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: const Text(LocaleKeys.clear_title).tr(),
        ),
      ],
    );
  }
}
