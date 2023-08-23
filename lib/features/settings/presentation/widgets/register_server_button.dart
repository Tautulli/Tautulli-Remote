import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';
import '../pages/server_registration_page.dart';

class RegisterServerButton extends StatelessWidget {
  const RegisterServerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      child: const Text(LocaleKeys.register_a_tautulli_server_title).tr(),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) {
              return const ServerRegistrationPage();
            },
          ),
        );
      },
    );
  }
}
