import 'package:flutter/material.dart';

import '../../../../core/widgets/grid_image_item.dart';
import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../pages/media_item_page.dart';

class AlbumsTab extends StatelessWidget {
  final MediaItem item;
  final List<MetadataItem> albums;

  const AlbumsTab({
    @required this.item,
    @required this.albums,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.count(
        crossAxisCount: 2,
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
    );
  }
}
