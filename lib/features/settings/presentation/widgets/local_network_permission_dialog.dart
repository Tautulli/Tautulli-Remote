import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';

import '../../../../translations/locale_keys.g.dart';
import '../bloc/settings_bloc.dart';

Future<void> showLocalNetworkPermissionDialog({
  @required BuildContext context,
  @required String ipAddress,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Local Network Access Permission Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'In order to connect to a local server Tautulli Remote needs the local network permission.',
            ),
            SizedBox(height: 8),
            Text(
              'Click CONTINUE and accept the prompt to allow this permission before registering.',
            ),
            SizedBox(height: 8),
            Text(
              'If denied you will need to manually enable this in the iOS settings.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(LocaleKeys.button_cancel).tr(),
          ),
          TextButton(
            onPressed: () {
              Ping(ipAddress, count: 1);
              context.read<SettingsBloc>().add(
                    SettingsUpdateIosLocalNetworkPermissionPrompted(true),
                  );
              Navigator.of(context).pop();
            },
            child: const Text('CONTINUE'),
          ),
        ],
      );
    },
  );
}
