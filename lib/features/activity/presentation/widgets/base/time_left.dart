import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import '../../../../../core/helpers/time_helper.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/activity_model.dart';

class TimeLeft extends StatelessWidget {
  final ActivityModel activity;

  const TimeLeft({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    if (activity.live == true && activity.channelCallSign != null) {
      return Text(activity.channelCallSign!);
    }

    if (activity.duration != null) {
      return Text(
        LocaleKeys.time_left_format.tr(
          args: [TimeHelper.timeLeft(activity.duration, activity.progressPercent)],
        ),
      );
    }

    return const SizedBox();
  }
}
