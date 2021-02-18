import 'package:flutter/material.dart';

import '../../../../core/widgets/grid_image_item.dart';
import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../pages/media_item_page.dart';

class MediaEpisodesTab extends StatelessWidget {
  final MediaItem item;
  final List<MetadataItem> episodes;

  const MediaEpisodesTab({
    @required this.item,
    @required this.episodes,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        children: episodes
            .map(
              (episode) => PosterGridItem(
                item: episode,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        MediaItem mediaItem = MediaItem(
                          mediaIndex: episode.mediaIndex,
                          mediaType: episode.mediaType,
                          parentMediaIndex: episode.parentMediaIndex,
                          grandparentTitle: item.parentTitle,
                          posterUrl: item.posterUrl,
                          ratingKey: episode.ratingKey,
                          title: episode.title,
                        );
                        return MediaItemPage(item: mediaItem);
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
