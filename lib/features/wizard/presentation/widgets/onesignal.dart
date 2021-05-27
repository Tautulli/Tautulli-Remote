import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../privacy/presentation/pages/privacy_page.dart';
import '../bloc/wizard_bloc.dart';

class OneSignal extends StatelessWidget {
  const OneSignal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 42),
      child: Column(
        children: [
          const Text(
            'OneSignal',
            style: TextStyle(
              fontSize: 20,
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
                  'Tautulli uses OneSignal to send notifications to Tautulli Remote. If you\'d like to receive notifications in Tautulli Remote review and accept the OneSignal data privacy below.',
                  style: TextStyle(fontSize: 16),
                ),
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
                                        context.read<OneSignalHealthBloc>().add(
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
                    return BlocBuilder<WizardBloc, WizardState>(
                      builder: (context, wizardState) {
                        if (wizardState is WizardLoaded) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: CheckboxListTile(
                              value: wizardState.onesignalAccepted,
                              onChanged: (value) {
                                context.read<WizardBloc>().add(
                                      WizardAcceptOneSignal(value),
                                    );
                              },
                              title: const Text(
                                'Consent to OneSignal data privacy',
                              ),
                            ),
                          );
                        }
                        return const SizedBox(height: 0, width: 0);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
