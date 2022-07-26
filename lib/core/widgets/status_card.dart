import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../translations/locale_keys.g.dart';

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
      height: 100 * MediaQuery.of(context).textScaleFactor,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    if (isFailure)
                      TextSpan(
                        text: '${LocaleKeys.failure_title.tr()}: ',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    TextSpan(
                      text: message,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              if (suggestion != null && suggestion != '')
                Text(
                  suggestion!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
