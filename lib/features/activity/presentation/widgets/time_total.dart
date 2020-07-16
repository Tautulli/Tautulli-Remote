import 'package:flutter/material.dart';

import '../../../../core/helpers/time_format_helper.dart';

class TimeTotal extends StatelessWidget {
  final int viewOffset;
  final int duration;

  const TimeTotal({
    Key key,
    @required this.viewOffset,
    @required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        '${TimeFormatHelper.hourMinSec(Duration(milliseconds: viewOffset))}/${TimeFormatHelper.hourMinSec(Duration(milliseconds: duration))}');
  }
}
