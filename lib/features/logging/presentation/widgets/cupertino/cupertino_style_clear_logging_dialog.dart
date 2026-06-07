import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/logging_bloc.dart';

class CupertinoStyleClearLoggingDialog extends StatelessWidget {
  const CupertinoStyleClearLoggingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(LocaleKeys.logs_clear_dialog_title).tr(),
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
            context.read<LoggingBloc>().add(LoggingClear());
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.clear_title).tr(),
        ),
      ],
    );
  }
}
