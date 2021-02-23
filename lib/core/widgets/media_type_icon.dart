import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/color_palette_helper.dart';

class MediaTypeIcon extends StatelessWidget {
  final String mediaType;
  final Color iconColor;

  const MediaTypeIcon({Key key, @required this.mediaType, this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _mapMediaTypeToIcon(mediaType, iconColor);
  }
}

FaIcon _mapMediaTypeToIcon(
  String mediaType,
  Color iconColor,
) {
  switch (mediaType) {
    case ('movie'):
      return FaIcon(
        FontAwesomeIcons.film,
        size: 18,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('episode'):
    case ('season'):
    case ('show'):
      return FaIcon(
        FontAwesomeIcons.tv,
        size: 14,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('track'):
    case ('album'):
      return FaIcon(
        FontAwesomeIcons.music,
        size: 16,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('photo'):
      return FaIcon(
        FontAwesomeIcons.image,
        size: 18,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('clip'):
      return FaIcon(
        FontAwesomeIcons.video,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('collection'):
      return FaIcon(
        FontAwesomeIcons.layerGroup,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('playlist'):
      return FaIcon(
        FontAwesomeIcons.list,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    default:
      return FaIcon(
        FontAwesomeIcons.questionCircle,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
  }
}
