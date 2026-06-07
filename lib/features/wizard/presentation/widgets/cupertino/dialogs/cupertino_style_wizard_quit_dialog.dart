import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleWizardQuitDialog extends StatelessWidget {
  const CupertinoStyleWizardQuitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(LocaleKeys.wizard_quit_dialog_title).tr(),
      actions: [
        CupertinoDialogAction(
          child: const Text(LocaleKeys.cancel_title).tr(),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        CupertinoDialogAction(
          child: const Text(
            LocaleKeys.quit_title,
            style: TextStyle(
              color: CupertinoColors.destructiveRed,
            ),
          ).tr(),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
