import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OnesignalDataPrivacyText extends StatelessWidget {
  const OnesignalDataPrivacyText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textBlock1 =
        'Tautulli Remote supports %end-to-end encryption%.'.split('%');
    final textBlock2 =
        '%OneSignal% is used to deliver notifications from Tautulli. No Personally Identifiable Information (PII) is being collected by OneSignal. Read the %OneSignal Privacy Policy% for more details.'
            .split('%');
    final textBlock3 =
        "Notification data sent through OneSignal's API will be %deleted after ~30 days%."
            .split('%');
    final textBlock4 =
        'Once you accept, this device will register with OneSignal. Consent can be revoked to prevent further communication with OneSignal.'
            .split('%');

    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16),
            children: [
              TextSpan(text: textBlock1[0]),
              TextSpan(
                text: textBlock1[1],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch(
                      'https://github.com/Tautulli/Tautulli/wiki/Frequently-Asked-Questions#notifications-pycryptodome',
                    );
                  },
              ),
              TextSpan(text: textBlock1[2]),
              TextSpan(
                text: '\n\n${textBlock2[1]}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch(
                      'https://onesignal.com/',
                    );
                  },
              ),
              TextSpan(text: textBlock2[2]),
              TextSpan(
                text: textBlock2[3],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch(
                      'https://onesignal.com/privacy',
                    );
                  },
              ),
              TextSpan(text: textBlock2[4]),
              TextSpan(
                text: '\n\n${textBlock3[0]}',
              ),
              TextSpan(
                text: textBlock3[1],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch(
                      'https://documentation.onesignal.com/docs/handling-personal-data#deleting-notification-data',
                    );
                  },
              ),
              TextSpan(text: textBlock3[2]),
              TextSpan(
                text: '\n\n${textBlock4[0]}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
