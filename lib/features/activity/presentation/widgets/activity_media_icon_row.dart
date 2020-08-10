import 'package:flutter/material.dart';

import '../../../../core/widgets/media_type_icon.dart';
import '../../../../core/widgets/transcode_decision_icon.dart';
import '../../domain/entities/activity.dart';

class ActivityMediaIconRow extends StatelessWidget {
  final ActivityItem activity;

  const ActivityMediaIconRow({
    Key key,
    @required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        MediaTypeIcon(
          mediaType: activity.mediaType,
        ),
        SizedBox(width: 5),
        TranscodeDecisionIcon(transcodeDecision: activity.transcodeDecision),
      ],
    );
  }
}
