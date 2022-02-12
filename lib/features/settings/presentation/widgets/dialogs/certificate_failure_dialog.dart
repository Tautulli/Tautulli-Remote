import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/register_device_bloc.dart';
import '../../bloc/settings_bloc.dart';

class CertificateFailureDialog extends StatelessWidget {
  const CertificateFailureDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Certificate Verification Failed'),
      content: const Text(
        'The certificate for this server could not be authenticated and may be self-signed. Do you want to trust this certificate?',
      ),
      actions: [
        TextButton(
          child: const Text('NO'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('TRUST'),
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            context.read<RegisterDeviceBloc>().add(
                  RegisterDeviceUnverifiedCert(context.read<SettingsBloc>()),
                );
          },
        ),
      ],
    );
  }
}
