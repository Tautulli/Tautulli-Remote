// @dart=2.9

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/color_palette_helper.dart';
import '../helpers/icon_mapper_helper.dart';

class TranscodeDecisionIcon extends StatelessWidget {
  final String transcodeDecision;

  const TranscodeDecisionIcon({
    Key key,
    @required this.transcodeDecision,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      IconMapperHelper.mapTranscodeDecisionToIcon(transcodeDecision),
      size: 15,
      color: TautulliColorPalette.not_white,
    );
  }
}
