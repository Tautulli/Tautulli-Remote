import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';

class WizardSkipDialog extends StatelessWidget {
  final String message;

  const WizardSkipDialog({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.wizard_skip_dialog_title).tr(),
      content: Text(
        message,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(LocaleKeys.cancel_button).tr(),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text(LocaleKeys.skip_button).tr(),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
