import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/color_palette_helper.dart';

class TranscodeDecisionIcon extends StatelessWidget {
  final String transcodeDecision;

  const TranscodeDecisionIcon({
    Key key,
    @required this.transcodeDecision,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _mapTranscodeDecisionToIcon(transcodeDecision);
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
