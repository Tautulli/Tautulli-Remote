import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../types/tautulli_types.dart';
import 'color_palette_helper.dart';

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

  static Widget mapWatchedStatusToIcon(WatchedStatus? watchedStatus) {
    const double size = 16;
    const Color color = TautulliColorPalette.notWhite;

    switch (watchedStatus) {
      case (WatchedStatus.high):
        return const FaIcon(
          FontAwesomeIcons.solidCircle,
          color: color,
          size: size,
        );
      case (WatchedStatus.medium):
        return Transform.rotate(
          angle: 180 * pi / 180,
          child: const FaIcon(
            FontAwesomeIcons.circleHalfStroke,
            color: color,
            size: size,
          ),
        );
      case (null):
      case (WatchedStatus.low):
      default: //TODO: Remove when Dart stops thinking default is needed even when all enum types are accounted for
        return const FaIcon(
          FontAwesomeIcons.circle,
          color: color,
          size: size,
        );
    }
  }
}
