// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../features/help/presentation/pages/help_page.dart';
import '../../translations/locale_keys.g.dart';
import '../error/failure.dart';
import '../helpers/failure_mapper_helper.dart';

Future<void> showFailureAlertDialog({
  @required BuildContext context,
  @required Failure failure,
  bool showHelp = false,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text(FailureMapperHelper.mapFailureToMessage(failure)),
        content: Text(FailureMapperHelper.mapFailureToSuggestion(failure)),
        actions: <Widget>[
          if (showHelp)
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const HelpPage(),
                  ),
                );
              },
              child: const Text(LocaleKeys.button_help).tr(),
            ),
          TextButton(
            child: const Text(LocaleKeys.button_close).tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
