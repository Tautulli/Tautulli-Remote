import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/helpers/failure_helper.dart';
import '../../../../../translations/locale_keys.g.dart';

class RegistrationFailureDialog extends StatelessWidget {
  final Failure failure;

  const RegistrationFailureDialog({
    super.key,
    required this.failure,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(FailureHelper.mapFailureToMessage(failure)),
      content: Text(FailureHelper.mapFailureToSuggestion(failure)),
      actions: [
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
  }
}
