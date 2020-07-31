import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key key}) : super(key: key);

  static const routeName = '/privacy';

  @override
  Widget build(BuildContext context) {
    final oneSignalPrivacyBloc = BlocProvider.of<OneSignalPrivacyBloc>(context);
    final oneSignalSubscriptionBloc =
        BlocProvider.of<OneSignalSubscriptionBloc>(context);
    final oneSignalHealthBloc = BlocProvider.of<OneSignalHealthBloc>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Privacy'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //! OneSignal Data Privacy
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'OneSignal Data Privacy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: _OneSignalDataPrivacyText(),
              ),
              BlocBuilder<OneSignalPrivacyBloc, OneSignalPrivacyState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SwitchListTile(
                      title: Text(
                        'Consent to OneSignal data privacy',
                        style: TextStyle(
                          color: TautulliColorPalette.not_white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: BlocBuilder<OneSignalPrivacyBloc,
                          OneSignalPrivacyState>(
                        builder: (context, state) {
                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Status: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                if (state is OneSignalPrivacyConsentFailure)
                                  TextSpan(
                                    text: 'Not Accepted X',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.red,
                                    ),
                                  ),
                                if (state is OneSignalPrivacyConsentSuccess)
                                  TextSpan(
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
                      onChanged: (_) {
                        if (state is OneSignalPrivacyConsentFailure) {
                          oneSignalPrivacyBloc
                              .add(OneSignalPrivacyGrantConsent());
                          oneSignalSubscriptionBloc
                              .add(OneSignalSubscriptionCheck());
                          oneSignalHealthBloc.add(OneSignalHealthCheck());
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

class _OneSignalDataPrivacyText extends StatelessWidget {
  const _OneSignalDataPrivacyText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16),
        children: [
          TextSpan(
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
          TextSpan(
            text: ' to handle delivery of notifications.',
          ),
          TextSpan(
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
          TextSpan(
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
          TextSpan(
            text:
                ' for more details. Without encryption the contents of the notifications are sent to OneSignal in plain text.',
          ),
          TextSpan(
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
          TextSpan(
            text: '.',
          ),
          TextSpan(
            text:
                '\n\nOnce you accept, this device will register with OneSignal. Consent can later be revoked to prevent further communication sent to OneSignal.',
          ),
        ],
      ),
    );
  }
}
