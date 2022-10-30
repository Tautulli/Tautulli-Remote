import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/media_type.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../history/presentation/bloc/individual_history_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/media_model.dart';
import '../bloc/children_metadata_bloc.dart';
import '../bloc/metadata_bloc.dart';
import 'album_media_page.dart';
import 'artist_media_page.dart';
import 'clip_media_page.dart';
import 'episode_media_page.dart';
import 'movie_media_page.dart';
import 'photo_album_media_page.dart';
import 'photo_media_page.dart';
import 'season_media_page.dart';
import 'show_media_page.dart';
import 'track_media_page.dart';

class MediaPage extends StatelessWidget {
  final MediaModel media;
  final Uri? parentPosterUri;
  final bool disableAppBarActions;

  const MediaPage({
    super.key,
    required this.media,
    this.parentPosterUri,
    this.disableAppBarActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<MetadataBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<ChildrenMetadataBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<IndividualHistoryBloc>(),
        ),
      ],
      child: MediaView(
        media: media,
        parentPosterUri: parentPosterUri,
        disableAppBarActions: disableAppBarActions,
      ),
    );
  }
}

class MediaView extends StatefulWidget {
  final MediaModel media;
  final Uri? parentPosterUri;
  final bool disableAppBarActions;

  const MediaView({
    super.key,
    required this.media,
    this.parentPosterUri,
    this.disableAppBarActions = false,
  });

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  late String _plexIdentifier;

  @override
  void initState() {
    super.initState();

    final settingsBloc = context.read<SettingsBloc>();
    final settingsState = settingsBloc.state as SettingsSuccess;
    final tautulliId = settingsState.appSettings.activeServer.tautulliId;
    _plexIdentifier = settingsState.appSettings.activeServer.plexIdentifier;

    context.read<MetadataBloc>().add(
          MetadataFetched(
            tautulliId: tautulliId,
            ratingKey: widget.media.ratingKey!,
            settingsBloc: settingsBloc,
          ),
        );

    context.read<IndividualHistoryBloc>().add(
          IndividualHistoryFetched(
            tautulliId: tautulliId,
            ratingKey: widget.media.ratingKey!,
            mediaType: widget.media.mediaType!,
            settingsBloc: settingsBloc,
          ),
        );

    if ([
      MediaType.show,
      MediaType.artist,
      MediaType.album,
      MediaType.season,
      MediaType.photoAlbum,
    ].contains(widget.media.mediaType!)) {
      context.read<ChildrenMetadataBloc>().add(
            ChildrenMetadataFetched(
              tautulliId: tautulliId,
              ratingKey: widget.media.ratingKey!,
              settingsBloc: settingsBloc,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.media.mediaType) {
      case MediaType.album:
        return AlbumMediaPage(
          media: widget.media,
          plexIdentifier: _plexIdentifier,
        );
      case MediaType.artist:
        return ArtistMediaPage(
          media: widget.media,
          plexIdentifier: _plexIdentifier,
        );
      case MediaType.clip:
        return ClipMediaPage(
          media: widget.media,
          plexIdentifier: _plexIdentifier,
        );
      case MediaType.episode:
        return EpisodeMediaPage(
          media: widget.media,
          parentPosterUri: widget.parentPosterUri,
          plexIdentifier: _plexIdentifier,
        );
      case MediaType.photo:
        return PhotoMediaPage(
          media: widget.media,
          plexIdentifier: _plexIdentifier,
          disableAppBarActions: widget.disableAppBarActions,
        );
      case MediaType.photoAlbum:
        return PhotoAlbumMediaPage(
          media: widget.media,
          plexIdentifier: _plexIdentifier,
        );
      case MediaType.season:
        return SeasonMediaPage(
          media: widget.media,
          plexIdentifier: _plexIdentifier,
        );
      case MediaType.show:
        return ShowMediaPage(
          media: widget.media,
          plexIdentifier: _plexIdentifier,
        );
      case MediaType.track:
        return TrackMediaPage(
          media: widget.media,
          plexIdentifier: _plexIdentifier,
        );
      case MediaType.movie:
      case MediaType.otherVideo:
      default:
        return MovieMediaPage(
          media: widget.media,
          plexIdentifier: _plexIdentifier,
        );
    }
  }
}
