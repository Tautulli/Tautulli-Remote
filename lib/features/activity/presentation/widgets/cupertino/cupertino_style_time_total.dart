import 'package:flutter/widgets.dart';
import 'package:tautulli_remote/core/helpers/time_helper.dart';

class CupertinoStyleTimeTotal extends StatelessWidget {
  final int viewOffset;
  final Duration duration;

  const CupertinoStyleTimeTotal({
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
