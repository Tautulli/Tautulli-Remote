import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/media_type_icon.dart';
import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../pages/media_item_page.dart';

class MediaPlaylistItemsTab extends StatelessWidget {
  final MediaItem item;
  final List<MetadataItem> items;

  const MediaPlaylistItemsTab({
    @required this.item,
    @required this.items,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    MediaItem mediaItem = MediaItem(
                      grandparentTitle: items[index].grandparentTitle,
                      mediaIndex: items[index].mediaIndex,
                      mediaType: items[index].mediaType,
                      parentMediaIndex: items[index].parentMediaIndex,
                      parentTitle: items[index].parentTitle,
                      ratingKey: items[index].ratingKey,
                      title: items[index].title,
                      year: items[index].year,
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
                    children: _playlistItemRowBuilder(
                      index: index,
                      item: items[index],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _playlistItemRowBuilder({
    @required int index,
    @required MetadataItem item,
  }) {
    return [
      Text(
        '${index < 9 ? "  " : ""}${index > 9 && index < 99 ? " " : ""}${index + 1}',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: MediaTypeIcon(
          mediaType: item.mediaType,
          iconColor: TautulliColorPalette.not_white,
        ),
      ),
      if (item.mediaType == 'episode')
        Expanded(
          child: Wrap(
            children: [
              Text('${item.grandparentTitle} - ${item.title} '),
              Text(
                '(S${item.parentMediaIndex} · E${item.mediaIndex})',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      if (item.mediaType == 'movie')
        Wrap(
          children: [
            Text('${item.title} '),
            Text(
              '(${item.year})',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      if (item.mediaType == 'track')
        Wrap(
          children: [
            Text('${item.title} '),
            Text(
              '(${item.parentTitle})',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      if (item.mediaType == 'photo')
        Wrap(
          children: [
            Text('${item.title} '),
            Text(
              '(${item.parentTitle})',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
    ];
  }
}
