import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class ChangeTypeTag extends StatelessWidget {
  final String type;

  const ChangeTypeTag(this.type, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    switch (type) {
      case 'important':
        text = 'NOTE';
        color = PlexColorPalette.cinnabar;
        break;
      case 'new':
        text = 'NEW';
        color = PlexColorPalette.gamboge;
        break;
      case 'improvement':
        text = 'IMPR';
        color = PlexColorPalette.curious_blue;
        break;
      case 'fix':
        text = 'FIX';
        color = Colors.green[600];
        break;
      default:
        text = '';
        color = Colors.transparent;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        padding: const EdgeInsets.only(top: 2),
        height: 16,
        width: 40,
        decoration: BoxDecoration(
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
