import 'package:flutter/material.dart';

import '../../domain/entities/library_media.dart';
import '../../domain/entities/media_item.dart';
import '../pages/media_item_page.dart';

class AlbumsTab extends StatelessWidget {
  final MediaItem item;
  final List<LibraryMedia> albums;

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
              (album) => Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          album.posterUrl,
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
                            Text('${album.year}'),
                            Text(
                              album.title,
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
                                  mediaIndex: album.mediaIndex,
                                  mediaType: album.mediaType,
                                  parentTitle: item.title,
                                  grandparentTitle: item.parentTitle,
                                  posterUrl: album.posterUrl,
                                  ratingKey: album.ratingKey,
                                  title: album.title,
                                  year: album.year,
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
