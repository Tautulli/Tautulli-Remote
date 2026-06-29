import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import '../../helpers/time_helper.dart';
import '../../../translations/locale_keys.g.dart';

class StatisticDurationRichText extends StatelessWidget {
  final Duration duration;
  final Color? textColor;

  const StatisticDurationRichText({
    super.key,
    required this.duration,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    final Map<String, int> durationMap = TimeHelper.durationMap(duration);

    return RichText(
      text: TextSpan(
        children: [
          if (durationMap['day']! > 1 || durationMap['hour']! > 1 || durationMap['min']! > 1 || durationMap['sec']! > 1)
            TextSpan(
              text: '${LocaleKeys.time_title.tr()} ',
            ),
          if (durationMap['day']! > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['day'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.days.tr()} ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          if (durationMap['hour']! > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['hour'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.hrs.tr()} ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          if (durationMap['min']! > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['min'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.mins.tr()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          if (durationMap['day']! < 1 && durationMap['hour']! < 1 && durationMap['min']! < 1 && durationMap['sec']! > 0)
            TextSpan(
              children: [
                TextSpan(
                  text: durationMap['sec'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: ' ${LocaleKeys.secs.tr()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
        ],
        style: TextStyle(color: textColor),
      ),
    );
  }
}
