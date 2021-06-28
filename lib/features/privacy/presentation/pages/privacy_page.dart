import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../translations/locale_keys.g.dart';
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
    final textBlock1 = LocaleKeys.privacy_text_block_1.tr().split('%');
    final textBlock2 = LocaleKeys.privacy_text_block_2.tr().split('%');
    final textBlock3 = LocaleKeys.privacy_text_block_3.tr().split('%');
    final textBlock4 = LocaleKeys.privacy_text_block_4.tr().split('%');

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16),
        children: [
          TextSpan(
            text: textBlock1[0],
          ),
          TextSpan(
            text: textBlock1[1],
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch('https://onesignal.com/');
              },
          ),
          TextSpan(
            text: textBlock1[2],
          ),
          TextSpan(
            text: '\n\n${textBlock2[0]}',
          ),
          TextSpan(
            text: textBlock2[1],
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(
                    'https://github.com/Tautulli/Tautulli-Wiki/wiki/Frequently-Asked-Questions#notifications-pycryptodome');
              },
          ),
          TextSpan(
            text: textBlock2[2],
          ),
          TextSpan(
            text: textBlock2[3],
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch('https://onesignal.com/privacy');
              },
          ),
          TextSpan(
            text: textBlock2[4],
          ),
          TextSpan(
            text: '\n\n${textBlock3[0]}',
          ),
          TextSpan(
            text: textBlock3[1],
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(
                    'https://documentation.onesignal.com/docs/handling-personal-data#deleting-notification-data');
              },
          ),
          TextSpan(
            text: textBlock3[2],
          ),
          TextSpan(
            text: '\n\n${textBlock4[0]}',
          ),
        ],
      ),
    );
  }
}