import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/register_device_bloc.dart';

class CupertinoStyleCertificateFailureDialog extends StatelessWidget {
  const CupertinoStyleCertificateFailureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoAlertDialog(
      title: const Text(LocaleKeys.certificate_verification_failed_title).tr(),
      content: const Text(LocaleKeys.certificate_verification_failed_content).tr(),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.no_title).tr(),
        ),
        CupertinoDialogAction(
          onPressed: () {
            context.read<RegisterDeviceBloc>().add(
              RegisterDeviceUnverifiedCert(),
            );

            Navigator.of(context).pop();
          },
          child: const Text(LocaleKeys.trust_title).tr(),
        ),
      ],
    );
  }
}
