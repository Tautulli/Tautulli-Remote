import 'package:flutter/material.dart';

import '../error/failure.dart';
import '../helpers/failure_message_helper.dart';

Future<void> showFailureAlertDialog({
  @required BuildContext context,
  @required Failure failure,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text(FailureMessageHelper().mapFailureToMessage(failure)),
        content: Text(FailureMessageHelper().mapFailureToSuggestion(failure)),
        actions: <Widget>[
          FlatButton(
            child: Text('CLOSE'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}