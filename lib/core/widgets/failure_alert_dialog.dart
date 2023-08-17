import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../translations/locale_keys.g.dart';
import '../error/failure.dart';
import '../helpers/failure_helper.dart';

Future<void> showFailureAlertDialog({
  required BuildContext context,
  required Failure failure,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(FailureHelper.mapFailureToMessage(failure)),
        content: Text(FailureHelper.mapFailureToSuggestion(failure)),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            child: const Text(LocaleKeys.close_title).tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
