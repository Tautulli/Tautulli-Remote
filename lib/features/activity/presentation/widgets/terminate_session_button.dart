import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class TerminateSessionButton extends StatelessWidget {
  const TerminateSessionButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.close,
          color: TautulliColorPalette.not_white,
          size: 30,
        ),
        Text(
          'Terminate Stream',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: TautulliColorPalette.not_white,
          ),
        ),
      ],
    );
  }
}
