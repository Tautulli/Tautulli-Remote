import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helpers/time_helper.dart';
import '../../../../../translations/locale_keys.g.dart';

class StatTimeRichText extends StatelessWidget {
  final int totalTime;
  final Color? labelColor;

  const StatTimeRichText({
    super.key,
    required this.totalTime,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    final durationMap = TimeHelper.durationMap(Duration(seconds: totalTime));

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: LocaleKeys.time_title.tr(),
            style: TextStyle(fontSize: 15, color: labelColor),
          ),
          const TextSpan(text: ' '),
          if (durationMap['day']! > 0) _timeTextSpan('${durationMap['day'].toString()} ${LocaleKeys.days.tr()} '),
          if (durationMap['hour']! > 0) _timeTextSpan('${durationMap['hour'].toString()} ${LocaleKeys.hrs.tr()} '),
          if (durationMap['min']! > 0) _timeTextSpan('${durationMap['min'].toString()} ${LocaleKeys.mins.tr()}'),
          if (durationMap['day']! < 1 && durationMap['hour']! < 1 && durationMap['min']! < 1 && durationMap['sec']! > 0)
            _timeTextSpan('${durationMap['sec'].toString()} ${LocaleKeys.secs.tr()}'),
          if (durationMap['day']! < 1 && durationMap['hour']! < 1 && durationMap['min']! < 1 && durationMap['sec']! < 1)
            _timeTextSpan('0 ${LocaleKeys.min.tr()}'),
        ],
      ),
    );
  }

  TextSpan _timeTextSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(fontWeight: FontWeight.w300),
    );
  }
}
