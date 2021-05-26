import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import '../../../privacy/presentation/pages/privacy_page.dart';
import '../bloc/wizard_bloc.dart';

class OneSignal extends StatefulWidget {
  const OneSignal({Key key}) : super(key: key);

  @override
  _OneSignalState createState() => _OneSignalState();
}

class _OneSignalState extends State<OneSignal> {
  @override
  void initState() {
    super.initState();
    context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());
  }

  @override
  Widget build(BuildContext context) {
    final oneSignalPrivacyBloc = context.read<OneSignalPrivacyBloc>();
    final oneSignalSubscriptionBloc = context.read<OneSignalSubscriptionBloc>();

    return BlocListener<OneSignalSubscriptionBloc, OneSignalSubscriptionState>(
      listener: (context, state) {
        if (state is OneSignalSubscriptionSuccess) {
          context.read<WizardBloc>().add(
                WizardOneSignalSubscribed(
                  true,
                ),
              );
        }
        if (state is OneSignalSubscriptionFailure) {
          context.read<WizardBloc>().add(
                WizardOneSignalSubscribed(
                  false,
                ),
              );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 34),
        child: Column(
          children: [
            const Text(
              'OneSignal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 17,
                    bottom: 8,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Text(
                      'Tautulli uses OneSignal to send notifications to Tautulli Remote. If you\'d like to receive notifications in Tautulli Remote review and accept the OneSignal data privacy below.'),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    // top: 17,
                    bottom: 8,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPage(
                                  showConsentSwitch: false,
                                ),
                              ),
                            );
                          },
                          child: const Text('VIEW ONESIGNAL DATA PRIVACY'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  indent: 8,
                  endIndent: 8,
                ),
                BlocBuilder<OneSignalHealthBloc, OneSignalHealthState>(
                  builder: (context, healthState) {
                    if (healthState is OneSignalHealthFailure) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            color: Colors.red[900],
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                right: 8,
                                left: 8,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: const [
                                      FaIcon(
                                        FontAwesomeIcons.exclamationCircle,
                                        color: TautulliColorPalette.not_white,
                                        size: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Unable to communicate with OneSignal. Please verify this device can reach onesignal.com.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<OneSignalHealthBloc>()
                                              .add(
                                                OneSignalHealthCheck(),
                                              );
                                        },
                                        child: const Text('CHECK AGAIN'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return BlocBuilder<OneSignalPrivacyBloc,
                          OneSignalPrivacyState>(
                        builder: (context, privacyState) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SwitchListTile(
                              title: const Text(
                                'Consent to OneSignal data privacy',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: BlocBuilder<OneSignalSubscriptionBloc,
                                  OneSignalSubscriptionState>(
                                builder: (context, subscriptionState) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text:
                                                  'OneSignal Privacy Consent: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            if (privacyState
                                                is OneSignalPrivacyConsentFailure)
                                              const TextSpan(
                                                text: 'Not Accepted X',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            if (privacyState
                                                is OneSignalPrivacyConsentSuccess)
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
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'OneSignal Registration: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            if (privacyState
                                                    is OneSignalPrivacyConsentFailure &&
                                                subscriptionState
                                                    is OneSignalSubscriptionFailure)
                                              const TextSpan(
                                                text: 'Not Registered X',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            if (privacyState
                                                    is OneSignalPrivacyConsentSuccess &&
                                                subscriptionState
                                                    is OneSignalSubscriptionFailure)
                                              TextSpan(
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                children: const [
                                                  TextSpan(
                                                    text: 'Registering ',
                                                  ),
                                                  WidgetSpan(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom: 3,
                                                      ),
                                                      child: SizedBox(
                                                        height: 10,
                                                        width: 10,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if (subscriptionState
                                                is OneSignalSubscriptionSuccess)
                                              const TextSpan(
                                                text: 'Registered ✓',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.green,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              value:
                                  privacyState is OneSignalPrivacyConsentSuccess
                                      ? true
                                      : false,
                              onChanged: (_) async {
                                if (privacyState
                                    is OneSignalPrivacyConsentFailure) {
                                  await _grantConsentFuture(
                                    oneSignalPrivacyBloc,
                                  );
                                  oneSignalSubscriptionBloc
                                      .add(OneSignalSubscriptionCheck());
                                  // oneSignalHealthBloc
                                  //     .add(OneSignalHealthCheck());
                                }
                                if (privacyState
                                    is OneSignalPrivacyConsentSuccess) {
                                  oneSignalPrivacyBloc
                                      .add(OneSignalPrivacyRevokeConsent());
                                  oneSignalSubscriptionBloc
                                      .add(OneSignalSubscriptionCheck());
                                  // oneSignalHealthBloc
                                  //     .add(OneSignalHealthCheck());
                                }
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _grantConsentFuture(OneSignalPrivacyBloc oneSignalPrivacyBloc) {
  oneSignalPrivacyBloc.add(OneSignalPrivacyGrantConsent());
  return Future.value(null);
}
