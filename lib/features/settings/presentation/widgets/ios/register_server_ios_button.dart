import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../pages/ios/server_registration_ios_page.dart';

class RegisterServerIosButton extends StatelessWidget {
  const RegisterServerIosButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoButton.filled(
        child: const Text(LocaleKeys.register_a_tautulli_server_title).tr(),
        onPressed: () => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => const ServerRegistrationIosPage(),
          ),
        ),
      ),
    );
  }
}
