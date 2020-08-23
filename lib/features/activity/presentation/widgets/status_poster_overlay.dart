import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class StatusPosterOverlay extends StatelessWidget {
  final String state;

  StatusPosterOverlay({@required this.state});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //* Faded background
        AspectRatio(
          aspectRatio: 2 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Opacity(
              opacity: 0.5,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        ),
        //* Icon
        AspectRatio(
          aspectRatio: 2 / 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(
                _mapStateToIcon(state),
                color: TautulliColorPalette.not_white,
                size: 50,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

IconData _mapStateToIcon(String state) {
  switch (state) {
    case 'paused':
      return FontAwesomeIcons.pauseCircle;
    case 'buffering':
      return FontAwesomeIcons.spinner;
    case 'playing':
      return FontAwesomeIcons.playCircle;
    default:
      return FontAwesomeIcons.exclamationCircle;
  }
}
