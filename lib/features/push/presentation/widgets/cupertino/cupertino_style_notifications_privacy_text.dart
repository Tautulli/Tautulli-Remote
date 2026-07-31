import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../../../../../translations/locale_keys.g.dart';

class CupertinoStyleNotificationsPrivacyText extends StatefulWidget {
  const CupertinoStyleNotificationsPrivacyText({super.key});

  @override
  State<CupertinoStyleNotificationsPrivacyText> createState() => _CupertinoStyleNotificationsPrivacyTextState();
}

class _CupertinoStyleNotificationsPrivacyTextState extends State<CupertinoStyleNotificationsPrivacyText> {
  late final TapGestureRecognizer _tapFaqRecognizer;
  late final TapGestureRecognizer _tapFirebaseRecognizer;

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
    _tapFirebaseRecognizer = TapGestureRecognizer()
      ..onTap = () {
        launchUrlString(
          mode: LaunchMode.externalApplication,
          'https://firebase.google.com/support/privacy',
        );
      };
  }

  @override
  void dispose() {
    _tapFaqRecognizer.dispose();
    _tapFirebaseRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    final textBlock1 = LocaleKeys.notifications_data_privacy_text_block_1.tr().split('%');
    final textBlock2 = LocaleKeys.notifications_data_privacy_text_block_2.tr().split('%');
    final textBlock3 = LocaleKeys.notifications_data_privacy_text_block_3.tr();
    final textBlock4 = LocaleKeys.notifications_data_privacy_text_block_4.tr();

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
              TextSpan(text: '\n\n${textBlock2[0]}'),
              TextSpan(
                text: textBlock2[1],
                style: TextStyle(
                  color: CupertinoTheme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer: _tapFirebaseRecognizer,
              ),
              TextSpan(text: textBlock2[2]),
              TextSpan(text: '\n\n$textBlock3'),
              TextSpan(text: '\n\n$textBlock4'),
            ],
          ),
        ),
      ),
    );
  }
}
