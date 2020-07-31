import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
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
        _mapMediaTypeToIcon(activity.mediaType),
        SizedBox(width: 5),
        _mapTranscodeDecisionToIcon(activity.transcodeDecision),
      ],
    );
  }
}

FaIcon _mapMediaTypeToIcon(String mediaType) {
  switch (mediaType) {
    case ('movie'):
      return FaIcon(
        FontAwesomeIcons.film,
        size: 18,
        color: TautulliColorPalette.not_white,
      );
    case ('episode'):
      return FaIcon(
        FontAwesomeIcons.tv,
        size: 14,
        color: TautulliColorPalette.not_white,
      );
    case ('track'):
      return FaIcon(
        FontAwesomeIcons.music,
        size: 16,
        color: TautulliColorPalette.not_white,
      );
    case ('photo'):
      return FaIcon(
        FontAwesomeIcons.image,
        size: 18,
        color: TautulliColorPalette.not_white,
      );
    case ('clip'):
      return FaIcon(
        FontAwesomeIcons.video,
        size: 17,
        color: TautulliColorPalette.not_white,
      );
    default:
      return FaIcon(
        FontAwesomeIcons.questionCircle,
        size: 17,
        color: TautulliColorPalette.not_white,
      );
  }
}

FaIcon _mapTranscodeDecisionToIcon(String transcodeDecision) {
  switch (transcodeDecision) {
    case ('transcode'):
      return FaIcon(
        FontAwesomeIcons.server,
        size: 15,
        color: TautulliColorPalette.not_white,
      );
    case ('copy'):
      return FaIcon(
        FontAwesomeIcons.stream,
        size: 18,
        color: TautulliColorPalette.not_white,
      );
    case ('direct play'):
      return FaIcon(
        FontAwesomeIcons.playCircle,
        size: 17,
        color: TautulliColorPalette.not_white,
      );
    default:
      return FaIcon(
        FontAwesomeIcons.questionCircle,
        size: 17,
        color: TautulliColorPalette.not_white,
      );
  }
}
