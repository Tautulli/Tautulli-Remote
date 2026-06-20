import 'package:flutter/material.dart';

import '../../../../../core/helpers/time_helper.dart';
import '../../../data/models/activity_model.dart';

class ActivityDetailsProgress extends StatelessWidget {
  final ActivityModel activity;

  const ActivityDetailsProgress({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
      child: Row(
        children: [
          if (activity.live != true && activity.duration != null && activity.viewOffset != null)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (activity.progressPercent != null) Text('${activity.progressPercent}%'),
                  Text(
                    '${TimeHelper.hourMinSec(Duration(milliseconds: activity.viewOffset!))}'
                    '/${TimeHelper.hourMinSec(activity.duration!)}',
                  ),
                ],
              ),
            ),
          if (activity.live == true)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Text('${activity.channelCallSign}')],
              ),
            ),
        ],
      ),
    );
  }
}
