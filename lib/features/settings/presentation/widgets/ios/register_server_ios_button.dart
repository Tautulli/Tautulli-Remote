import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../pages/ios/server_registration_ios_page.dart';

class RegisterServerIosButton extends StatelessWidget {
  final bool isWizard;

  const RegisterServerIosButton({
    super.key,
    this.isWizard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isWizard ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 20),
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
