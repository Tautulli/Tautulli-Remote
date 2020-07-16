import 'package:flutter/material.dart';

import '../../../../core/helpers/time_format_helper.dart';

class TimeLeft extends StatelessWidget {
  final int duration;
  final int progressPercent;

  const TimeLeft({
    Key key,
    @required this.duration,
    @required this.progressPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('${TimeFormatHelper.timeLeft(duration, progressPercent)} left');
  }
}
