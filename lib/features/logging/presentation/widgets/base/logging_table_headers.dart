import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import '../../../../../translations/locale_keys.g.dart';

class LoggingTableHeaders extends StatelessWidget {
  const LoggingTableHeaders({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    const double textSize = 13;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFF000000),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.only(
              top: 14,
              bottom: 14,
              left: 12,
            ),
            child: Text(
              LocaleKeys.timestamp_title.tr(),
              style: const TextStyle(
                fontSize: textSize,
              ),
            ),
          ),
          Container(
            width: 86,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 6,
            ),
            child: Text(
              LocaleKeys.level_title.tr(),
              style: const TextStyle(
                fontSize: textSize,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 6,
                right: 12,
              ),
              child: Text(
                LocaleKeys.message_title.tr(),
                style: const TextStyle(
                  fontSize: textSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
