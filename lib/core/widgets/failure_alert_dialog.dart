import 'package:flutter/material.dart';

import '../error/failure.dart';
import '../helpers/failure_mapper_helper.dart';

Future<void> showFailureAlertDialog({
  @required BuildContext context,
  @required Failure failure,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text(FailureMapperHelper.mapFailureToMessage(failure)),
        content: Text(FailureMapperHelper.mapFailureToSuggestion(failure)),
        actions: <Widget>[
          TextButton(
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
