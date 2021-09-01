// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';
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
    Tab(
      text: LocaleKeys.media_tab_details.tr(),
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
            ? LocaleKeys.media_tab_seasons.tr()
            : mediaType == 'season'
                ? LocaleKeys.media_tab_episodes.tr()
                : mediaType == 'artist'
                    ? LocaleKeys.media_tab_albums.tr()
                    : mediaType == 'album'
                        ? LocaleKeys.media_tab_tracks.tr()
                        : mediaType == 'collection'
                            ? LocaleKeys.media_tab_movies.tr()
                            : LocaleKeys.media_tab_media.tr(),
      ),
    if (!['photo', 'clip', 'collection', 'playlist'].contains(mediaType))
      Tab(
        text: LocaleKeys.history_page_title.tr(),
      ),
  ];
}
