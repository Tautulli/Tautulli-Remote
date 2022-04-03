import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/helpers/failure_helper.dart';
import '../../../../../translations/locale_keys.g.dart';

class RegistrationFailureDialog extends StatelessWidget {
  final Failure failure;

  const RegistrationFailureDialog({
    Key? key,
    required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(FailureHelper.mapFailureToMessage(failure)),
      content: Text(FailureHelper.mapFailureToSuggestion(failure)),
      actions: [
        TextButton(
          child: const Text(LocaleKeys.close_button).tr(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}