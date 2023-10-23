import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../painters/quarter_circle_progress_painter.dart';
import '../types/tautulli_types.dart';

class IconHelper {
  static IconData mapStateToIcon(String state) {
    switch (state) {
      case 'paused':
        return FontAwesomeIcons.circlePause;
      case 'buffering':
        return FontAwesomeIcons.spinner;
      case 'playing':
        return FontAwesomeIcons.circlePlay;
      case 'error':
        return FontAwesomeIcons.triangleExclamation;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  static IconData mapMediaTypeToIcon(MediaType? mediaType) {
    switch (mediaType) {
      case (MediaType.movie):
        return FontAwesomeIcons.film;
      case (MediaType.episode):
      case (MediaType.season):
      case (MediaType.show):
        return FontAwesomeIcons.tv;
      case (MediaType.track):
      case (MediaType.album):
        return FontAwesomeIcons.music;
      case (MediaType.photo):
        return FontAwesomeIcons.image;
      case (MediaType.clip):
        return FontAwesomeIcons.video;
      case (MediaType.collection):
        return FontAwesomeIcons.layerGroup;
      case (MediaType.playlist):
        return FontAwesomeIcons.list;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  static IconData mapTranscodeDecisionToIcon(StreamDecision? transcodeDecision) {
    switch (transcodeDecision) {
      case (StreamDecision.transcode):
        return FontAwesomeIcons.server;
      case (StreamDecision.copy):
        return FontAwesomeIcons.barsStaggered;
      case (StreamDecision.directPlay):
        return FontAwesomeIcons.solidCirclePlay;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  static Widget mapWatchedStatusToIcon({
    required BuildContext context,
    WatchedStatus? watchedStatus,
  }) {
    const double size = 16;
    final Color color = Theme.of(context).colorScheme.onSurface;

    return Stack(
      children: [
        Positioned(
          child: SizedBox(
            width: size,
            height: size,
            child: ClipRect(
              child: CustomPaint(
                painter: QuarterCircleProgressPainter(
                  quarterCircleProgress: watchedStatus == WatchedStatus.empty
                      ? QuarterCircleProgress.empty
                      : watchedStatus == WatchedStatus.quarter
                          ? QuarterCircleProgress.quarter
                          : watchedStatus == WatchedStatus.half
                              ? QuarterCircleProgress.twoquarter
                              : watchedStatus == WatchedStatus.threeQuarter
                                  ? QuarterCircleProgress.threequarter
                                  : QuarterCircleProgress.full,
                  color: color,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
