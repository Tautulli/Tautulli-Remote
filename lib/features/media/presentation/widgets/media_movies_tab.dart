import 'package:flutter/material.dart';

import '../../../../core/widgets/grid_image_item.dart';
import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../pages/media_item_page.dart';

class MediaMoviesTab extends StatelessWidget {
  final MediaItem item;
  final List<MetadataItem> movies;

  const MediaMoviesTab({
    @required this.item,
    @required this.movies,
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
          childAspectRatio: 2 / 3,
          children: movies
              .map(
                (movie) => PosterGridItem(
                  item: movie,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          MediaItem mediaItem = MediaItem(
                              mediaIndex: movie.mediaIndex,
                              mediaType: movie.mediaType,
                              parentMediaIndex: movie.parentMediaIndex,
                              parentTitle: item.title,
                              posterUrl: movie.posterUrl,
                              ratingKey: movie.ratingKey,
                              title: movie.title,
                              year: movie.year);
                          return MediaItemPage(
                            item: mediaItem,
                            heroTag: movie.ratingKey,
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
