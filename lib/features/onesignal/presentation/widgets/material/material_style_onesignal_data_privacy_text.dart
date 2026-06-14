import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/widgets/material/material_style_card.dart';
import '../../../../../translations/locale_keys.g.dart';

class MaterialStyleOnesignalDataPrivacyText extends StatefulWidget {
  const MaterialStyleOnesignalDataPrivacyText({super.key});

  @override
  State<MaterialStyleOnesignalDataPrivacyText> createState() =>
      _MaterialStyleOnesignalDataPrivacyTextState();
}

class _MaterialStyleOnesignalDataPrivacyTextState extends State<MaterialStyleOnesignalDataPrivacyText> {
  late final TapGestureRecognizer _tapFaqRecognizer;
  late final TapGestureRecognizer _tapOnesignalRecognizer;
  late final TapGestureRecognizer _tapPrivacyRecognizer;
  late final TapGestureRecognizer _tapDeletionRecognizer;

  @override
  void initState() {
    super.initState();
    _tapFaqRecognizer = TapGestureRecognizer()
      ..onTap = () {
        launchUrlString(
          mode: LaunchMode.externalApplication,
          'https://github.com/Tautulli/Tautulli/wiki/Frequently-Asked-Questions#notifications-pycryptodome',
        );
      };
    _tapOnesignalRecognizer = TapGestureRecognizer()
      ..onTap = () {
        launchUrlString(
          mode: LaunchMode.externalApplication,
          'https://onesignal.com/',
        );
      };
    _tapPrivacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        launchUrlString(
          mode: LaunchMode.externalApplication,
          'https://onesignal.com/privacy',
        );
      };
    _tapDeletionRecognizer = TapGestureRecognizer()
      ..onTap = () {
        launchUrlString(
          mode: LaunchMode.externalApplication,
          'https://documentation.onesignal.com/docs/handling-personal-data#deleting-notification-data',
        );
      };
  }

  @override
  void dispose() {
    _tapFaqRecognizer.dispose();
    _tapOnesignalRecognizer.dispose();
    _tapPrivacyRecognizer.dispose();
    _tapDeletionRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textBlock1 = LocaleKeys.onesignal_data_privacy_text_block_1.tr().split('%');
    final textBlock2 = LocaleKeys.onesignal_data_privacy_text_block_2.tr().split('%');
    final textBlock3 = LocaleKeys.onesignal_data_privacy_text_block_3.tr().split('%');
    final textBlock4 = LocaleKeys.onesignal_data_privacy_text_block_4.tr().split('%');

    return MaterialStyleCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            children: [
              TextSpan(text: textBlock1[0]),
              TextSpan(
                text: textBlock1[1],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: _tapFaqRecognizer,
              ),
              TextSpan(text: textBlock1[2]),
              TextSpan(
                text: '\n\n${textBlock2[1]}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: _tapOnesignalRecognizer,
              ),
              TextSpan(text: textBlock2[2]),
              TextSpan(
                text: textBlock2[3],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: _tapPrivacyRecognizer,
              ),
              TextSpan(text: textBlock2[4]),
              TextSpan(
                text: '\n\n${textBlock3[0]}',
              ),
              TextSpan(
                text: textBlock3[1],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: _tapDeletionRecognizer,
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
