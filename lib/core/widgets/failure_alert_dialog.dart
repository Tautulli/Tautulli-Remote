import 'package:flutter/material.dart';

import '../../features/help/presentation/pages/help_page.dart';
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
              child: const Text('HELP'),
            ),
          TextButton(
            child: const Text('CLOSE'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
