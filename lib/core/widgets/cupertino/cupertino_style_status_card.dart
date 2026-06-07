import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../translations/locale_keys.g.dart';
import 'cupertino_style_card.dart';

class CupertinoStyleStatusCard extends StatelessWidget {
  final bool isFailure;
  final String message;
  final String? suggestion;

  const CupertinoStyleStatusCard({
    super.key,
    this.isFailure = false,
    required this.message,
    this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(1) > 1 ? 100 * MediaQuery.of(context).textScaler.scale(1) : 100,
      child: CupertinoStyleCard(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    if (isFailure)
                      TextSpan(
                        text: '${LocaleKeys.failure_title.tr()}: ',
                        style: const TextStyle(fontSize: 15),
                      ),
                    TextSpan(
                      text: message,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              if (suggestion != null && suggestion != '')
                Text(
                  suggestion!,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
