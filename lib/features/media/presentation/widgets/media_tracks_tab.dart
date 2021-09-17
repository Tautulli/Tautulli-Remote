// @dart=2.9

import 'package:flutter/material.dart';

import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../pages/media_item_page.dart';

class MediaTracksTab extends StatelessWidget {
  final MediaItem item;
  final List<MetadataItem> tracks;

  const MediaTracksTab({
    @required this.item,
    @required this.tracks,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Scrollbar(
        child: ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      MediaItem mediaItem = MediaItem(
                        grandparentTitle: item.parentTitle,
                        mediaIndex: tracks[index].mediaIndex,
                        mediaType: tracks[index].mediaType,
                        parentMediaIndex: tracks[index].parentMediaIndex,
                        parentTitle: item.title,
                        posterUrl: item.posterUrl,
                        ratingKey: tracks[index].ratingKey,
                        title: tracks[index].title,
                      );
                      return MediaItemPage(item: mediaItem);
                    },
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? Colors.black26 : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        if (tracks[index].mediaIndex != null)
                          Text('${tracks[index].mediaIndex}. '),
                        Expanded(
                          child: Text(
                            tracks[index].title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
