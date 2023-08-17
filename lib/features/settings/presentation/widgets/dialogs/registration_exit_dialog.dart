import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/registration_headers_bloc.dart';

class RegistrationExitDialog extends StatelessWidget {
  const RegistrationExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.server_registration_exit_dialog_title).tr(),
      content: const Text(LocaleKeys.server_registration_exit_dialog_content).tr(),
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
            context.read<RegistrationHeadersBloc>().add(
                  RegistrationHeadersClear(),
                );
            Navigator.of(context).pop(true);
          },
          child: const Text(LocaleKeys.discard_title).tr(),
        ),
      ],
    );
  }
}
