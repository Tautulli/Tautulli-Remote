import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'color_palette_helper.dart';

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

  static IconData mapMediaTypeToIcon(String mediaType) {
    switch (mediaType) {
      case ('movie'):
        return FontAwesomeIcons.film;
      case ('episode'):
      case ('season'):
      case ('show'):
        return FontAwesomeIcons.tv;
      case ('track'):
      case ('album'):
        return FontAwesomeIcons.music;
      case ('photo'):
        return FontAwesomeIcons.image;
      case ('clip'):
        return FontAwesomeIcons.video;
      case ('collection'):
        return FontAwesomeIcons.layerGroup;
      case ('playlist'):
        return FontAwesomeIcons.list;
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
      case ('direct play'):
        return FontAwesomeIcons.playCircle;
      default:
        return FontAwesomeIcons.questionCircle;
    }
  }

  static Widget mapWatchedStatusToIcon(num watchedStatus) {
    const double size = 16;
    const Color color = TautulliColorPalette.not_white;

    if (watchedStatus == 1) {
      return const FaIcon(
        FontAwesomeIcons.solidCircle,
        color: color,
        size: size,
      );
    } else if (watchedStatus == 0.5) {
      return Transform.rotate(
        angle: 180 * pi / 180,
        child: const FaIcon(
          FontAwesomeIcons.adjust,
          color: color,
          size: size,
        ),
      );
    } else {
      return const FaIcon(
        FontAwesomeIcons.circle,
        color: color,
        size: size,
      );
    }
  }
}
