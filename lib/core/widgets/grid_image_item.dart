import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'poster_chooser.dart';

class PosterGridItem extends StatelessWidget {
  final dynamic item;
  final Function onTap;
  final dynamic heroTag;

  const PosterGridItem({
    @required this.item,
    this.onTap,
    this.heroTag,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: heroTag ?? item.ratingKey,
              child: PosterChooser(item: item),
            ),
          ),
          //* Gradient layer to make text visible
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                  stops: [
                    [
                      'album',
                      'episode',
                    ].contains(item.mediaType)
                        ? 0.5
                        : 0.8,
                    1.0,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 4,
            right: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.mediaType == 'album') Text('${item.year}'),
                if (item.mediaType == 'episode')
                  Text('Episode ${item.mediaIndex}'),
                Text(
                  item.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (['photo_album', 'clip'].contains(item.mediaType))
            Positioned(
              top: 4,
              right: 4,
              child: FaIcon(
                item.mediaType == 'photo_album'
                    ? FontAwesomeIcons.solidFolderOpen
                    : FontAwesomeIcons.video,
                color: Colors.white70,
              ),
            ),
          // Draw InkWell over rest of stack
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap),
            ),
          ),
        ],
      ),
    );
  }
}
