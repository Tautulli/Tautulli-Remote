import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../translations/locale_keys.g.dart';

class StatPlaysRichText extends StatelessWidget {
  final int totalPlays;
  final Color? textColor;

  const StatPlaysRichText({
    super.key,
    required this.totalPlays,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: LocaleKeys.plays_title.tr(),
            style: const TextStyle(fontSize: 15),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: totalPlays.toString(),
            style: const TextStyle(fontWeight: FontWeight.w300),
          ),
        ],
        style: textColor != null ? TextStyle(color: textColor) : null,
      ),
    );
  }
}
