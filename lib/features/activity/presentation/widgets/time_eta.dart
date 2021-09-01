// @dart=2.9

import 'package:flutter/material.dart';

import '../../../../core/helpers/time_format_helper.dart';

class TimeEta extends StatelessWidget {
  final int duration;
  final int progressPercent;
  final String timeFormat;

  const TimeEta({
    Key key,
    @required this.duration,
    @required this.progressPercent,
    @required this.timeFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      TimeFormatHelper.eta(duration, progressPercent, timeFormat),
    );
  }
}
