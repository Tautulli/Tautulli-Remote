import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../translations/locale_keys.g.dart';
import '../../error/failure.dart';
import '../../helpers/failure_helper.dart';

Future<void> showCupertinoStyleFailureAlertDialog({
  required BuildContext context,
  required Failure failure,
}) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(FailureHelper.mapFailureToMessage(failure)),
        content: Text(FailureHelper.mapFailureToSuggestion(failure)),
        actions: <Widget>[
          CupertinoDialogAction(
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
