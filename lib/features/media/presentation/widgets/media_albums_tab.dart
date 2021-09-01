// @dart=2.9

import 'package:flutter/material.dart';

import '../../../../core/widgets/grid_image_item.dart';
import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../pages/media_item_page.dart';

class MediaAlbumsTab extends StatelessWidget {
  final MediaItem item;
  final List<MetadataItem> albums;

  const MediaAlbumsTab({
    @required this.item,
    @required this.albums,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Scrollbar(
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1,
          children: albums
              .map(
                (album) => PosterGridItem(
                  item: album,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          MediaItem mediaItem = MediaItem(
                            mediaIndex: album.mediaIndex,
                            mediaType: album.mediaType,
                            parentTitle: item.title,
                            grandparentTitle: item.parentTitle,
                            posterUrl: album.posterUrl,
                            ratingKey: album.ratingKey,
                            title: album.title,
                            year: album.year,
                          );
                          return MediaItemPage(
                            item: mediaItem,
                            heroTag: album.ratingKey,
                          );
                        },
                      ),
                    );
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
