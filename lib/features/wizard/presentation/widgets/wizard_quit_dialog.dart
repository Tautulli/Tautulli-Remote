import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';

class WizardQuitDialog extends StatelessWidget {
  const WizardQuitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.wizard_quit_dialog_title).tr(),
      actions: [
        TextButton(
          child: const Text(LocaleKeys.cancel_button).tr(),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text(LocaleKeys.quit_button).tr(),
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).errorColor,
          ),
          onPressed: () {
            //TODO
            // context
            //     .read<SettingsBloc>()
            //     .add(SettingsUpdateWizardCompleteStatus(true));

            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
