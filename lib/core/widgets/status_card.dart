import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../translations/locale_keys.g.dart';
import 'card_with_forced_tint.dart';

class StatusCard extends StatelessWidget {
  final bool isFailure;
  final String message;
  final String? suggestion;

  const StatusCard({
    super.key,
    this.isFailure = false,
    required this.message,
    this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(1) > 1 ? 100 * MediaQuery.of(context).textScaler.scale(1) : 100,
      child: CardWithForcedTint(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    if (isFailure)
                      TextSpan(
                        text: '${LocaleKeys.failure_title.tr()}: ',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    TextSpan(
                      text: message,
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              if (suggestion != null && suggestion != '')
                Text(
                  suggestion!,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
