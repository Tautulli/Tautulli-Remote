import 'package:flutter/material.dart';

import '../../data/models/activity_model.dart';

class ProgressBar extends StatelessWidget {
  final ActivityModel activity;

  const ProgressBar({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Stack(
        children: [
          LinearProgressIndicator(
            minHeight: 5,
            backgroundColor: Colors.black26,
            valueColor: AlwaysStoppedAnimation(Theme.of(context).textTheme.titleSmall!.color),
            value: ((activity.transcodeProgress ?? 0) / 100).toDouble(),
          ),
          LinearProgressIndicator(
            minHeight: 5,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
            value: ((activity.live != true ? (activity.progressPercent ?? 0) : 100) / 100).toDouble(),
          ),
        ],
      ),
    );
  }
}
