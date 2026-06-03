import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../history/presentation/bloc/individual_history_bloc.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/media_model.dart';
import '../../bloc/children_metadata_bloc.dart';
import '../../bloc/metadata_bloc.dart';
import 'album_media_ios_page.dart';
import 'artist_media_ios_page.dart';
import 'clip_media_ios_page.dart';
import 'episode_media_ios_page.dart';
import 'movie_media_ios_page.dart';
import 'photo_album_media_ios_page.dart';
import 'photo_media_ios_page.dart';
import 'season_media_ios_page.dart';
import 'show_media_ios_page.dart';
import 'track_media_ios_page.dart';

class MediaIosPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final Uri? parentPosterUri;
  final String previousPageTitle;
  final bool disableAppBarActions;
  final bool disableAncestryNavigation;

  const MediaIosPage({
    super.key,
    required this.server,
    required this.media,
    this.parentPosterUri,
    this.previousPageTitle = '',
    this.disableAppBarActions = false,
    this.disableAncestryNavigation = false,
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
      child: MediaIosView(
        server: server,
        media: media,
        parentPosterUri: parentPosterUri,
        previousPageTitle: previousPageTitle,
        disableAppBarActions: disableAppBarActions,
        disableAncestryNavigation: disableAncestryNavigation,
      ),
    );
  }
}

class MediaIosView extends StatefulWidget {
  final ServerModel server;
  final MediaModel media;
  final String previousPageTitle;
  final Uri? parentPosterUri;
  final bool disableAppBarActions;
  final bool disableAncestryNavigation;

  const MediaIosView({
    super.key,
    required this.server,
    required this.media,
    required this.previousPageTitle,
    this.parentPosterUri,
    this.disableAppBarActions = false,
    this.disableAncestryNavigation = false,
  });

  @override
  State<MediaIosView> createState() => _MediaIosViewState();
}

class _MediaIosViewState extends State<MediaIosView> {
  @override
  void initState() {
    super.initState();

    final settingsBloc = context.read<SettingsBloc>();

    context.read<MetadataBloc>().add(
      MetadataFetched(
        server: widget.server,
        ratingKey: widget.media.ratingKey!,
        settingsBloc: settingsBloc,
      ),
    );

    context.read<IndividualHistoryBloc>().add(
      IndividualHistoryFetched(
        server: widget.server,
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
          server: widget.server,
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
        return AlbumMediaIosPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.artist:
        return ArtistMediaIosPage(
          server: widget.server,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.clip:
        return ClipMediaIosPage(
          server: widget.server,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.episode:
        return EpisodeMediaIosPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
          parentPosterUri: widget.parentPosterUri,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.photo:
        return PhotoMediaIosPage(
          server: widget.server,
          media: widget.media,
          disableAppBarActions: widget.disableAppBarActions,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.photoAlbum:
        return PhotoAlbumMediaIosPage(
          server: widget.server,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.season:
        return SeasonMediaIosPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.show:
        return ShowMediaIosPage(
          server: widget.server,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.track:
        return TrackMediaIosPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.movie:
      case MediaType.otherVideo:
      default:
        return MovieMediaIosPage(
          server: widget.server,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
    }
  }
}
