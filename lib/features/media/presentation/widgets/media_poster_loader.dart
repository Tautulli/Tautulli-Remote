import 'package:flutter/material.dart';

import '../../domain/entities/media_item.dart';

class MediaPosterLoader extends StatelessWidget {
  final String syncedMediaType;
  final MediaItem item;
  final Object heroTag;
  final Widget child;

  const MediaPosterLoader({
    @required this.syncedMediaType,
    @required this.item,
    @required this.heroTag,
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: [
        'artist',
        'album',
        'track',
        'photo',
        'playlist',
      ].contains(syncedMediaType ?? item.mediaType)
          ? MediaQuery.of(context).padding.top -
              AppBar().preferredSize.height +
              124
          : MediaQuery.of(context).padding.top -
              AppBar().preferredSize.height +
              58,
      child: Container(
        width: 137,
        padding: EdgeInsets.only(left: 4),
        child: Hero(
          tag: heroTag ?? UniqueKey(),
          child: AspectRatio(
            aspectRatio: [
              'artist',
              'album',
              'track',
              'photo',
              'playlist',
            ].contains(syncedMediaType ?? item.mediaType)
                ? 1
                : 2 / 3,
            child: child,
          ),
        ),
      ),
    );
  }
}
