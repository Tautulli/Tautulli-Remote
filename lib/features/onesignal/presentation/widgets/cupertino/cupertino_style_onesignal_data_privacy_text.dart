import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../../../../../translations/locale_keys.g.dart';

class CupertinoStyleOnesignalDataPrivacyText extends StatefulWidget {
  const CupertinoStyleOnesignalDataPrivacyText({super.key});

  @override
  State<CupertinoStyleOnesignalDataPrivacyText> createState() => _CupertinoStyleOnesignalDataPrivacyTextState();
}

class _CupertinoStyleOnesignalDataPrivacyTextState extends State<CupertinoStyleOnesignalDataPrivacyText> {
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
    context.locale; // Re-run translations in place on a language change.
    final textBlock1 = LocaleKeys.onesignal_data_privacy_text_block_1.tr().split('%');
    final textBlock2 = LocaleKeys.onesignal_data_privacy_text_block_2.tr().split('%');
    final textBlock3 = LocaleKeys.onesignal_data_privacy_text_block_3.tr().split('%');
    final textBlock4 = LocaleKeys.onesignal_data_privacy_text_block_4.tr().split('%');

    return CupertinoStyleCard(
      horizontalPadding: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16),
            children: [
              TextSpan(text: textBlock1[0]),
              TextSpan(
                text: textBlock1[1],
                style: TextStyle(
                  color: CupertinoTheme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer: _tapFaqRecognizer,
              ),
              TextSpan(text: textBlock1[2]),
              TextSpan(
                text: '\n\n${textBlock2[1]}',
                style: TextStyle(
                  color: CupertinoTheme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer: _tapOnesignalRecognizer,
              ),
              TextSpan(text: textBlock2[2]),
              TextSpan(
                text: textBlock2[3],
                style: TextStyle(
                  color: CupertinoTheme.of(context).primaryColor,
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
                  color: CupertinoTheme.of(context).primaryColor,
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
