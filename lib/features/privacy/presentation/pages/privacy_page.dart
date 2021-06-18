import 'dart:io' show Platform;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import '../widgets/notification_setting_dialog.dart';

class PrivacyPage extends StatelessWidget {
  final bool showConsentSwitch;

  const PrivacyPage({
    Key key,
    this.showConsentSwitch = true,
  }) : super(key: key);

  static const routeName = '/privacy';

  @override
  Widget build(BuildContext context) {
    final oneSignalPrivacyBloc = context.read<OneSignalPrivacyBloc>();
    final oneSignalSubscriptionBloc = context.read<OneSignalSubscriptionBloc>();
    final oneSignalHealthBloc = context.read<OneSignalHealthBloc>();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('OneSignal Data Privacy'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //! OneSignal Data Privacy
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: _OneSignalDataPrivacyText(),
              ),
              if (showConsentSwitch)
                BlocBuilder<OneSignalPrivacyBloc, OneSignalPrivacyState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SwitchListTile(
                        title: const Text(
                          'Consent to OneSignal data privacy',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: BlocBuilder<OneSignalPrivacyBloc,
                            OneSignalPrivacyState>(
                          builder: (context, state) {
                            return RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Status: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  if (state is OneSignalPrivacyConsentFailure)
                                    const TextSpan(
                                      text: 'Not Accepted X',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.red,
                                      ),
                                    ),
                                  if (state is OneSignalPrivacyConsentSuccess)
                                    const TextSpan(
                                      text: 'Accepted ✓',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.green,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        value: state is OneSignalPrivacyConsentSuccess
                            ? true
                            : false,
                        onChanged: (_) async {
                          if (state is OneSignalPrivacyConsentFailure) {
                            if (Platform.isIOS) {
                              if (await Permission.notification
                                  .request()
                                  .isGranted) {
                                await _grantConsentFuture(oneSignalPrivacyBloc);
                                oneSignalSubscriptionBloc
                                    .add(OneSignalSubscriptionCheck());
                                oneSignalHealthBloc.add(OneSignalHealthCheck());
                              } else {
                                await showNotificationSettingsDialog(context);
                              }
                            } else {
                              await _grantConsentFuture(oneSignalPrivacyBloc);
                              oneSignalSubscriptionBloc
                                  .add(OneSignalSubscriptionCheck());
                              oneSignalHealthBloc.add(OneSignalHealthCheck());
                            }
                          }
                          if (state is OneSignalPrivacyConsentSuccess) {
                            oneSignalPrivacyBloc
                                .add(OneSignalPrivacyRevokeConsent());
                            oneSignalSubscriptionBloc
                                .add(OneSignalSubscriptionCheck());
                            oneSignalHealthBloc.add(OneSignalHealthCheck());
                          }
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _grantConsentFuture(OneSignalPrivacyBloc oneSignalPrivacyBloc) {
  oneSignalPrivacyBloc.add(OneSignalPrivacyGrantConsent());
  return Future.value(null);
}

class _OneSignalDataPrivacyText extends StatelessWidget {
  const _OneSignalDataPrivacyText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16),
        children: [
          const TextSpan(
            text: 'Tautulli Remote uses ',
          ),
          TextSpan(
            text: 'OneSignal',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch('https://onesignal.com/');
              },
          ),
          const TextSpan(
            text: ' to handle delivery of notifications.',
          ),
          const TextSpan(
            text: '\n\nWith ',
          ),
          TextSpan(
            text: 'encryption enabled',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(
                    'https://github.com/Tautulli/Tautulli-Wiki/wiki/Frequently-Asked-Questions#notifications-pycryptodome');
              },
          ),
          const TextSpan(
            text:
                ' in Tautulli there is no Personally Identifiable Information (PII) collected. Some non-PII user information is collected and cannot be encrypted. Read the ',
          ),
          TextSpan(
            text: 'OneSignal Privacy Policy',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch('https://onesignal.com/privacy');
              },
          ),
          const TextSpan(
            text:
                ' for more details. Without encryption the contents of the notifications are sent to OneSignal in plain text.',
          ),
          const TextSpan(
            text:
                '\n\nNotification data sent through OneSignal\'s API will be ',
          ),
          TextSpan(
            text: 'deleted after ~30 days',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(
                    'https://documentation.onesignal.com/docs/handling-personal-data#deleting-notification-data');
              },
          ),
          const TextSpan(
            text: '.',
          ),
          const TextSpan(
            text:
                '\n\nOnce you accept, this device will register with OneSignal. Consent can be revoked to prevent further communication with OneSignal.',
          ),
        ],
      ),
    );
  }
}
