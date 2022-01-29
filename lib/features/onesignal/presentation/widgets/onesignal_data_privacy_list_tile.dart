import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/widgets/permission_setting_dialog.dart';
import '../bloc/onesignal_health_bloc.dart';
import '../bloc/onesignal_privacy_bloc.dart';

class OneSignalDataPrivacyListTile extends StatelessWidget {
  const OneSignalDataPrivacyListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final oneSignalPrivacyBloc = context.read<OneSignalPrivacyBloc>();
    final oneSignalHealthBloc = context.read<OneSignalHealthBloc>();

    return BlocBuilder<OneSignalPrivacyBloc, OneSignalPrivacyState>(
      builder: (context, state) {
        return Material(
          child: SwitchListTile(
            title: const Text('Consent to OneSignal data privacy'),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Status: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    if (state is OneSignalPrivacyFailure)
                      TextSpan(
                        text: 'Not Accepted X',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                    if (state is OneSignalPrivacySuccess)
                      const TextSpan(
                        text: 'Accepted ✓',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            value: state is OneSignalPrivacySuccess,
            onChanged: (_) async {
              // If current state is OneSignalPrivacyFailure then go through the
              // steps to grant permission.
              if (state is OneSignalPrivacyFailure) {
                // If the platform is iOS make sure the notification persmission
                // has been granted.
                if (Platform.isIOS) {
                  if (await Permission.notification.request().isGranted) {
                    oneSignalPrivacyBloc.add(OneSignalPrivacyGrant());
                    oneSignalHealthBloc.add(OneSignalHealthCheck());
                  } else {
                    await showDialog(
                      context: context,
                      builder: (context) => const PermissionSettingDialog(
                        title: 'Notification Permission Disabled',
                        content:
                            'The notification permission is required to receive notifications.',
                      ),
                    );
                  }
                } else {
                  oneSignalPrivacyBloc.add(OneSignalPrivacyGrant());
                  oneSignalHealthBloc.add(OneSignalHealthCheck());
                }
              }
              // If current state is OneSignalPrivacySuccess then revoke consent
              if (state is OneSignalPrivacySuccess) {
                oneSignalPrivacyBloc.add(OneSignalPrivacyRevoke());
                oneSignalHealthBloc.add(OneSignalHealthCheck());
              }
            },
          ),
        );
      },
    );
  }
}
