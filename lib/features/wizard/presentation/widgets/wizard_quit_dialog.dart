import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

class WizardQuitDialog extends StatelessWidget {
  const WizardQuitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.wizard_quit_dialog_title).tr(),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: const Text(LocaleKeys.cancel_title).tr(),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            context.read<SettingsBloc>().add(const SettingsUpdateWizardComplete(true));

            Navigator.of(context).pop(true);
          },
          child: const Text(LocaleKeys.quit_title).tr(),
        ),
      ],
    );
  }
}
