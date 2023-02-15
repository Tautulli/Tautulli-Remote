import 'package:flutter/material.dart';

import '../../../../core/helpers/time_helper.dart';

class TimeTotal extends StatelessWidget {
  final int viewOffset;
  final Duration duration;

  const TimeTotal({
    super.key,
    required this.viewOffset,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${TimeHelper.hourMinSec(Duration(milliseconds: viewOffset))}/${TimeHelper.hourMinSec(duration)}',
      style: const TextStyle(
        fontSize: 13,
      ),
    );
  }
}
