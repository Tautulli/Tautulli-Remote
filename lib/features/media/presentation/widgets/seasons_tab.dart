import 'package:flutter/material.dart';

import '../../../../core/widgets/poster_chooser.dart';
import '../../domain/entities/library_media.dart';
import '../../domain/entities/media_item.dart';
import '../pages/media_item_page.dart';

class SeasonsTab extends StatelessWidget {
  final MediaItem item;
  final List<LibraryMedia> seasons;

  const SeasonsTab({
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
              (season) => Padding(
                padding: const EdgeInsets.all(4),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: season.ratingKey,
                        child: PosterChooser(item: season),
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
                                  0.8,
                                  1.0
                                ])),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Text(season.title),
                    ),
                    // Draw InkWell over rest of stack
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
