import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/error/failure.dart';
import '../../../../../../core/helpers/failure_helper.dart';
import '../../../../../../translations/locale_keys.g.dart';

class RegistrationFailureIosDialog extends StatelessWidget {
  final Failure failure;

  const RegistrationFailureIosDialog({
    super.key,
    required this.failure,
  });

  @override
  Widget build(BuildContext context) {
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
