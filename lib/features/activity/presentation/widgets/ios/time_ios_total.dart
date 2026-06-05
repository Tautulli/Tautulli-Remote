import 'package:flutter/widgets.dart';
import 'package:tautulli_remote/core/helpers/time_helper.dart';

class TimeIosTotal extends StatelessWidget {
  final int viewOffset;
  final Duration duration;

  const TimeIosTotal({
    super.key,
    required this.viewOffset,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${TimeHelper.hourMinSec(Duration(milliseconds: viewOffset))}/${TimeHelper.hourMinSec(duration)}',
    );
  }
}
