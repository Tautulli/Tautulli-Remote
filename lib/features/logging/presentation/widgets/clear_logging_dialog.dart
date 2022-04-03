import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';
import '../bloc/logging_bloc.dart';

class ClearLoggingDialog extends StatelessWidget {
  final LoggingBloc loggingBloc;

  const ClearLoggingDialog(
    this.loggingBloc, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.logs_clear_dialog_title).tr(),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.cancel_button).tr(),
        ),
        TextButton(
          onPressed: () {
            loggingBloc.add(LoggingClear());
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.clear_button).tr(),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}