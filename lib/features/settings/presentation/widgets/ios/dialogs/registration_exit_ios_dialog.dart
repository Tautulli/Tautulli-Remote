import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../translations/locale_keys.g.dart';

class RegistrationExitIosDialog extends StatelessWidget {
  const RegistrationExitIosDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(LocaleKeys.server_registration_exit_dialog_title).tr(),
      content: const Text(LocaleKeys.server_registration_exit_dialog_content).tr(),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(LocaleKeys.cancel_title).tr(),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text(LocaleKeys.discard_title).tr(),
        ),
      ],
    );
  }
}
