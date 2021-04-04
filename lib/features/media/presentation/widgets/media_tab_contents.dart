import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/error_message.dart';
import '../../domain/entities/media_item.dart';
import '../bloc/children_metadata_bloc.dart';
import 'media_albums_tab.dart';
import 'media_details_tab.dart';
import 'media_episodes_tab.dart';
import 'media_history_tab.dart';
import 'media_movies_tab.dart';
import 'media_playlist_items_tab.dart';
import 'media_seasons_tab.dart';
import 'media_tracks_tab.dart';

class MediaTabContents extends StatelessWidget {
  final MediaItem item;
  final String mediaType;
  final bool metadataFailed;

  const MediaTabContents({
    @required this.item,
    this.mediaType,
    this.metadataFailed = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        // Details Tab
        const MediaDetailsTab(),
        // Loading tab for when no mediaType is provided and we need to get
        // it from the fetched metadata
        if (mediaType == null && item.mediaType == null && !metadataFailed)
          const Center(
            child: CircularProgressIndicator(),
          ),
        // Seasons/Episodes/Albums/Tracks tab
        if (['show', 'season', 'artist', 'album', 'collection', 'playlist']
            .contains(mediaType ?? item.mediaType))
          BlocBuilder<ChildrenMetadataBloc, ChildrenMetadataState>(
            builder: (context, state) {
              if (state is ChildrenMetadataFailure) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ErrorMessage(
                      failure: state.failure,
                      message: state.message,
                      suggestion: state.suggestion,
                    ),
                  ],
                );
              }
              if (state is ChildrenMetadataSuccess) {
                if (['show'].contains(mediaType ?? item.mediaType)) {
                  return MediaSeasonsTab(
                    item: item,
                    seasons: state.childrenMetadataList,
                  );
                }
                if (['season'].contains(mediaType ?? item.mediaType)) {
                  return MediaEpisodesTab(
                    item: item,
                    episodes: state.childrenMetadataList,
                  );
                }
                if (['artist'].contains(mediaType ?? item.mediaType)) {
                  return MediaAlbumsTab(
                    item: item,
                    albums: state.childrenMetadataList,
                  );
                }
                if (['album'].contains(mediaType ?? item.mediaType)) {
                  return MediaTracksTab(
                    item: item,
                    tracks: state.childrenMetadataList,
                  );
                }
                if (['collection'].contains(mediaType ?? item.mediaType)) {
                  return MediaMoviesTab(
                    item: item,
                    movies: state.childrenMetadataList,
                  );
                }
                if (['playlist'].contains(mediaType ?? item.mediaType)) {
                  return MediaPlaylistItemsTab(
                    item: item,
                    items: state.childrenMetadataList,
                  );
                }
                return Text(
                    'UNKNOWN MEDIA TYPE ${mediaType ?? item.mediaType}');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        // History Tab
        if (![
          'photo',
          'clip',
          'collection',
          'playlist',
        ].contains(mediaType ?? item.mediaType))
          MediaHistoryTab(
            ratingKey: item.ratingKey,
            mediaType: mediaType ?? item.mediaType,
            imageUrl: item.posterUrl,
          ),
      ],
    );
  }
}
