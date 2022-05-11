import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../translations/locale_keys.g.dart';

class OnesignalDataPrivacyText extends StatelessWidget {
  const OnesignalDataPrivacyText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textBlock1 =
        LocaleKeys.onesignal_data_privacy_text_block_1.tr().split('%');
    final textBlock2 =
        LocaleKeys.onesignal_data_privacy_text_block_2.tr().split('%');
    final textBlock3 =
        LocaleKeys.onesignal_data_privacy_text_block_3.tr().split('%');
    final textBlock4 =
        LocaleKeys.onesignal_data_privacy_text_block_4.tr().split('%');

    return Card(
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
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrlString(
                      'https://github.com/Tautulli/Tautulli/wiki/Frequently-Asked-Questions#notifications-pycryptodome',
                    );
                  },
              ),
              TextSpan(text: textBlock1[2]),
              TextSpan(
                text: '\n\n${textBlock2[1]}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrlString(
                      'https://onesignal.com/',
                    );
                  },
              ),
              TextSpan(text: textBlock2[2]),
              TextSpan(
                text: textBlock2[3],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrlString(
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
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrlString(
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
