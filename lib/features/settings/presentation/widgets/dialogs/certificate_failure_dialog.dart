import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/register_device_bloc.dart';
import '../../bloc/settings_bloc.dart';

class CertificateFailureDialog extends StatelessWidget {
  const CertificateFailureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.certificate_verification_failed_title).tr(),
      content:
          const Text(LocaleKeys.certificate_verification_failed_content).tr(),
      actions: [
        TextButton(
          child: const Text(LocaleKeys.no_button).tr(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            context.read<RegisterDeviceBloc>().add(
                  RegisterDeviceUnverifiedCert(context.read<SettingsBloc>()),
                );
          },
          child: const Text(LocaleKeys.trust_button).tr(),
        ),
      ],
    );
  }
}
