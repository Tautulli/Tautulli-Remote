// @dart=2.9

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/color_palette_helper.dart';
import '../helpers/icon_mapper_helper.dart';

class MediaTypeIcon extends StatelessWidget {
  final String mediaType;
  final Color iconColor;

  const MediaTypeIcon({Key key, @required this.mediaType, this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _mapMediaTypeToIconWidget(mediaType, iconColor);
  }
}

FaIcon _mapMediaTypeToIconWidget(
  String mediaType,
  Color iconColor,
) {
  final icon = IconMapperHelper.mapMediaTypeToIcon(mediaType);

  switch (mediaType) {
    case ('movie'):
      return FaIcon(
        icon,
        size: 18,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('episode'):
    case ('season'):
    case ('show'):
      return FaIcon(
        icon,
        size: 14,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('track'):
    case ('album'):
      return FaIcon(
        icon,
        size: 16,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('photo'):
      return FaIcon(
        icon,
        size: 18,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('clip'):
      return FaIcon(
        icon,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('collection'):
      return FaIcon(
        icon,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case ('playlist'):
      return FaIcon(
        icon,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    default:
      return FaIcon(
        icon,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
  }
}
