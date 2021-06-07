import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';

class TerminateSessionButton extends StatelessWidget {
  const TerminateSessionButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const FaIcon(
          FontAwesomeIcons.times,
          color: TautulliColorPalette.not_white,
        ),
        const Text(
          LocaleKeys.button_terminate_stream,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ).tr(),
      ],
    );
  }
}
