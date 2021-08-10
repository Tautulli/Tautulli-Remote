import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';

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
        title: const Text(
          LocaleKeys.settings_alert_ios_local_network_permission_title,
        ).tr(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              LocaleKeys.settings_alert_ios_local_network_permission_content_1,
            ).tr(),
            const SizedBox(height: 8),
            const Text(
              LocaleKeys.settings_alert_ios_local_network_permission_content_2,
            ).tr(),
            const SizedBox(height: 8),
            const Text(
              LocaleKeys.settings_alert_ios_local_network_permission_content_3,
            ).tr(),
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
              // final ping = Ping(ipAddress, count: 1);
              // ping.stream.listen((event) {});
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
