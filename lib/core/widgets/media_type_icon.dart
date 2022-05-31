import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/icon_helper.dart';
import '../types/media_type.dart';

class MediaTypeIcon extends StatelessWidget {
  final MediaType? mediaType;
  final Color? iconColor;

  const MediaTypeIcon({
    super.key,
    required this.mediaType,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final icon = IconHelper.mapMediaTypeToIcon(mediaType);

    FaIcon _buildMediaIcon(double size) {
      return FaIcon(
        icon,
        size: size,
        color: iconColor,
      );
    }

    switch (mediaType) {
      case (MediaType.episode):
      case (MediaType.season):
      case (MediaType.show):
        return _buildMediaIcon(14);
      case (MediaType.track):
      case (MediaType.album):
        return _buildMediaIcon(16);
      case (MediaType.movie):
      case (MediaType.photo):
        return _buildMediaIcon(18);
      case (MediaType.clip):
      case (MediaType.collection):
      case (MediaType.playlist):
      default:
        return _buildMediaIcon(17);
    }
  }
}
