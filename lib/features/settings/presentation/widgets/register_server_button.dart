import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';
import '../pages/server_registration_page.dart';

class RegisterServerButton extends StatelessWidget {
  const RegisterServerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text(LocaleKeys.register_a_tautulli_server_button).tr(),
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
