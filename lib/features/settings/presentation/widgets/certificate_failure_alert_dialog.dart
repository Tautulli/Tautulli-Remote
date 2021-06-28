import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';
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
        title: const Text(LocaleKeys.settings_certificate_dialog_title).tr(),
        content: const Text(
          LocaleKeys.settings_certificate_dialog_content,
        ).tr(),
        actions: <Widget>[
          TextButton(
            child: const Text(LocaleKeys.button_no).tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).accentColor,
            ),
            child: const Text(LocaleKeys.button_trust).tr(),
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
