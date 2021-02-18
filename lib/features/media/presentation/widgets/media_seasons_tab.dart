import 'package:flutter/material.dart';

import '../../../../core/widgets/grid_image_item.dart';
import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../pages/media_item_page.dart';

class MediaSeasonsTab extends StatelessWidget {
  final MediaItem item;
  final List<MetadataItem> seasons;

  const MediaSeasonsTab({
    @required this.item,
    @required this.seasons,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        children: seasons
            .map(
              (season) => PosterGridItem(
                item: season,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        MediaItem mediaItem = MediaItem(
                          mediaIndex: season.mediaIndex,
                          mediaType: season.mediaType,
                          parentMediaIndex: season.parentMediaIndex,
                          parentTitle: item.title,
                          posterUrl: season.posterUrl,
                          ratingKey: season.ratingKey,
                          title: season.title,
                        );
                        return MediaItemPage(
                          item: mediaItem,
                          heroTag: season.ratingKey,
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
