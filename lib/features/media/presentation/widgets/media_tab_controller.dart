import 'package:flutter/material.dart';

import '../../domain/entities/media_item.dart';
import 'media_tab_contents.dart';

class MediaTabController extends StatelessWidget {
  final int length;
  final String mediaType;
  final MediaItem item;
  final bool metadataFailed;

  const MediaTabController({
    @required this.length,
    @required this.item,
    this.mediaType,
    this.metadataFailed = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: length,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              tabs: _tabBuilder(
                context,
                mediaType: mediaType,
                metadataFailed: metadataFailed,
              ),
            ),
          ),
          Expanded(
            child: MediaTabContents(
              item: item,
              mediaType: mediaType,
              metadataFailed: metadataFailed,
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _tabBuilder(
  BuildContext context, {
  String mediaType,
  bool metadataFailed = false,
}) {
  return [
    const Tab(
      text: 'Details',
    ),
    if (mediaType == null && !metadataFailed)
      Tab(
        child: SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    // if (mediaType != null)
    if ([
      'show',
      'season',
      'artist',
      'album',
      'collection',
      'playlist',
    ].contains(mediaType))
      Tab(
        text: mediaType == 'show'
            ? 'Seasons'
            : mediaType == 'season'
                ? 'Episodes'
                : mediaType == 'artist'
                    ? 'Albums'
                    : mediaType == 'album'
                        ? 'Tracks'
                        : mediaType == 'collection'
                            ? 'Movies'
                            : 'Media',
      ),
    if (!['photo', 'clip', 'collection', 'playlist'].contains(mediaType))
      const Tab(
        text: 'History',
      ),
  ];
}
