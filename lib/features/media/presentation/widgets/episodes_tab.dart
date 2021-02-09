import 'package:flutter/material.dart';

import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../pages/media_item_page.dart';

class EpisodesTab extends StatelessWidget {
  final MediaItem item;
  final List<MetadataItem> episodes;

  const EpisodesTab({
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
              (episode) => Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          episode.posterUrl,
                          fit: BoxFit.cover,
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
                                    0.5,
                                    1.0
                                  ])),
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
                            Text('Episode ${episode.mediaIndex}'),
                            Text(
                              episode.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Draw InkWell over rest of stack
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
