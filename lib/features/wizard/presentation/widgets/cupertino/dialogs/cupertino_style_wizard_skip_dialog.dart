import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleWizardSkipDialog extends StatelessWidget {
  final String message;

  const CupertinoStyleWizardSkipDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(LocaleKeys.wizard_skip_dialog_title).tr(),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: const Text(LocaleKeys.cancel_title).tr(),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        CupertinoDialogAction(
          child: const Text(LocaleKeys.skip_title).tr(),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
