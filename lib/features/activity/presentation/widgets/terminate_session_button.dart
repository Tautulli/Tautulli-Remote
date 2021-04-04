import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class TerminateSessionButton extends StatelessWidget {
  const TerminateSessionButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        FaIcon(
          FontAwesomeIcons.times,
          color: TautulliColorPalette.not_white,
        ),
        Text(
          'Terminate Stream',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
