import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/error/failure.dart';
import '../../../../../../core/helpers/failure_helper.dart';
import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleRegistrationFailureDialog extends StatelessWidget {
  final Failure failure;

  const CupertinoStyleRegistrationFailureDialog({
    super.key,
    required this.failure,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoAlertDialog(
      title: Text(FailureHelper.mapFailureToMessage(failure)),
      content: Text(FailureHelper.mapFailureToSuggestion(failure)),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.close_title).tr(),
        ),
      ],
    );
  }
}
