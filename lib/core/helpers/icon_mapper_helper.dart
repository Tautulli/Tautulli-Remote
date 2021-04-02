import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconMapperHelper {
  static IconData mapStateToIcon(String state) {
    switch (state) {
      case 'paused':
        return FontAwesomeIcons.pauseCircle;
      case 'buffering':
        return FontAwesomeIcons.spinner;
      case 'playing':
        return FontAwesomeIcons.playCircle;
      case 'error':
        return FontAwesomeIcons.exclamationTriangle;
      default:
        return FontAwesomeIcons.questionCircle;
    }
  }

  static IconData mapTranscodeDecisionToIcon(String transcodeDecision) {
    switch (transcodeDecision) {
      case ('transcode'):
        return FontAwesomeIcons.server;
      case ('copy'):
        return FontAwesomeIcons.stream;
      case ('play'):
        return FontAwesomeIcons.playCircle;
      default:
        return FontAwesomeIcons.questionCircle;
    }
  }

  static Widget mapWatchedStatusToIcon(num watchedStatus) {
    const double size = 16;
    const Color color = Colors.grey;

    if (watchedStatus == 1) {
      return FaIcon(
        FontAwesomeIcons.solidCircle,
        color: color,
        size: size,
      );
    } else if (watchedStatus == 0.5) {
      return Transform.rotate(
        angle: 180 * pi / 180,
        child: FaIcon(
          FontAwesomeIcons.adjust,
          color: color,
          size: size,
        ),
      );
    } else {
      return FaIcon(
        FontAwesomeIcons.circle,
        color: color,
        size: size,
      );
    }
  }
}
