import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/icon_helper.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/types/stream_decision.dart';
import '../../data/models/activity_model.dart';

class StreamIcons extends StatelessWidget {
  final ActivityModel activity;

  const StreamIcons({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    late double mediaTypeIconSize;
    late double transcodeDecisionIconSize;

    switch (activity.mediaType) {
      case (MediaType.episode):
      case (MediaType.season):
      case (MediaType.show):
        mediaTypeIconSize = 13;
        break;
      case (MediaType.movie):
      case (MediaType.clip):
        mediaTypeIconSize = 15;
        break;
      default:
        mediaTypeIconSize = 14;
    }

    switch (activity.transcodeDecision) {
      case (StreamDecision.directPlay):
        transcodeDecisionIconSize = 14;
        break;
      default:
        transcodeDecisionIconSize = 15;
    }

    return Row(
      children: [
        FaIcon(
          IconHelper.mapMediaTypeToIcon(activity.mediaType),
          size: mediaTypeIconSize,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        const Gap(4),
        FaIcon(
          IconHelper.mapTranscodeDecisionToIcon(activity.transcodeDecision),
          size: transcodeDecisionIconSize,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ],
    );
  }
}
