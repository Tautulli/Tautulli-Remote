import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../core/types/media_type.dart';
import '../../../data/models/activity_model.dart';

class ProgressBar extends StatelessWidget {
  final ActivityModel activity;
  final Color backgroundColor;
  final Color transcodeColor;
  final Color progressColor;

  const ProgressBar({
    super.key,
    required this.activity,
    required this.backgroundColor,
    required this.transcodeColor,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    late int transcodeProgress;
    late int progressPercent;

    if (activity.mediaType == MediaType.photo || activity.live == true) {
      transcodeProgress = 0;
      progressPercent = 100;
    } else {
      // This is a more accurate way to identify transcode progress as Plex does some weird stuff with transcodeProgress
      // Only use transcodeProgress as a fall back
      if (activity.transcodeMaxOffsetAvailable != null &&
          activity.progressPercent != null &&
          activity.duration != null) {
        transcodeProgress = (((activity.transcodeMaxOffsetAvailable! * 1000) / activity.duration!.inMilliseconds) * 100)
            .floor();
      } else {
        if (activity.transcodeProgress != null && activity.transcodeProgress!.isNegative) {
          transcodeProgress = activity.transcodeProgress! * -1;
        } else {
          transcodeProgress = activity.transcodeProgress ?? 0;
        }
      }

      progressPercent = activity.progressPercent ?? 0;
    }

    return Stack(
      children: [
        LinearPercentIndicator(
          lineHeight: 5,
          backgroundColor: backgroundColor,
          progressColor: transcodeColor,
          barRadius: const Radius.circular(4),
          percent: ((transcodeProgress) / 100).toDouble(),
        ),
        LinearPercentIndicator(
          lineHeight: 5,
          backgroundColor: const Color(0x00000000),
          progressColor: progressColor,
          barRadius: const Radius.circular(4),
          percent: ((activity.live != true ? (progressPercent) : 100) / 100).toDouble(),
        ),
      ],
    );
  }
}
