import 'package:flutter/material.dart';

import '../../../../core/helpers/time_format_helper.dart';

class TimeEta extends StatelessWidget {
  final int duration;
  final int progressPercent;

  const TimeEta({
    Key key,
    @required this.duration,
    @required this.progressPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(TimeFormatHelper.eta24Hour(duration, progressPercent));
  }
}
