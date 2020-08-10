import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/color_palette_helper.dart';

class ServerHeader extends StatelessWidget {
  final String serverName;
  final bool alert;

  const ServerHeader({
    Key key,
    @required this.serverName,
    this.alert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        top: 8,
        bottom: 8,
      ),
      child: Row(
        children: <Widget>[
          Text(
            serverName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).accentColor,
            ),
          ),
          if (alert == true)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: FaIcon(
                FontAwesomeIcons.exclamationCircle,
                size: 15,
                color: TautulliColorPalette.not_white,
              ),
            ),
        ],
      ),
    );
  }
}
