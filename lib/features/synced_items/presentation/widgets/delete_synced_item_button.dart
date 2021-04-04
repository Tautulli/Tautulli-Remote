import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class DeleteSyncedItemButton extends StatelessWidget {
  const DeleteSyncedItemButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const FaIcon(
            FontAwesomeIcons.trashAlt,
            size: 20,
            color: TautulliColorPalette.not_white,
          ),
          const SizedBox(height: 4),
          const Text(
            'Delete',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
