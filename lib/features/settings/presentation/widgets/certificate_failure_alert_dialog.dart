import 'package:flutter/material.dart';

import '../bloc/register_device_bloc.dart';
import '../bloc/settings_bloc.dart';

Future<void> showCertificateFailureAlertDialog({
  @required BuildContext context,
  @required RegisterDeviceBloc registerDeviceBloc,
  @required SettingsBloc settingsBloc,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text('Certificate Verification Failed'),
        content: Text(
          'This servers certificate could not be authenticated and may be self-signed. Do you want to trust this certificate?',
        ),
        actions: <Widget>[
          TextButton(
            child: Text('NO'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).accentColor,
            ),
            child: Text('TRUST'),
            onPressed: () {
              Navigator.of(context).pop();
              registerDeviceBloc.add(
                RegisterDeviceUnverifiedCert(
                  settingsBloc: settingsBloc,
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
