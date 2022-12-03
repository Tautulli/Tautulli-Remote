import 'package:flutter/material.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../data/models/activity_model.dart';

class TimeLeft extends StatelessWidget {
  final ActivityModel activity;

  const TimeLeft({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    if (activity.live == true && activity.channelCallSign != null) {
      return Text(activity.channelCallSign!);
    }

    if (activity.duration != null) {
      return Text(
        '${TimeHelper.timeLeft(activity.duration, activity.progressPercent)} left',
      );
    }

    return const SizedBox();
  }
}
