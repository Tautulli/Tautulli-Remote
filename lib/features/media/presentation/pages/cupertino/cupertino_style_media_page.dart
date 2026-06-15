import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../history/presentation/bloc/individual_history_bloc.dart';
import '../../../../logging/domain/usecases/logging.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/media_model.dart';
import '../../bloc/children_metadata_bloc.dart';
import '../../bloc/metadata_bloc.dart';
import 'cupertino_style_album_media_page.dart';
import 'cupertino_style_artist_media_page.dart';
import 'cupertino_style_clip_media_page.dart';
import 'cupertino_style_episode_media_page.dart';
import 'cupertino_style_movie_media_page.dart';
import 'cupertino_style_photo_album_media_page.dart';
import 'cupertino_style_photo_media_page.dart';
import 'cupertino_style_season_media_page.dart';
import 'cupertino_style_show_media_page.dart';
import 'cupertino_style_track_media_page.dart';

class CupertinoStyleMediaPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final Uri? parentPosterUri;
  final String? previousPageTitle;
  final bool disableAppBarActions;
  final bool disableAncestryNavigation;

  const CupertinoStyleMediaPage({
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
      child: CupertinoStyleMediaView(
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

class CupertinoStyleMediaView extends StatefulWidget {
  final ServerModel server;
  final MediaModel media;
  final String? previousPageTitle;
  final Uri? parentPosterUri;
  final bool disableAppBarActions;
  final bool disableAncestryNavigation;

  const CupertinoStyleMediaView({
    super.key,
    required this.server,
    required this.media,
    required this.previousPageTitle,
    this.parentPosterUri,
    this.disableAppBarActions = false,
    this.disableAncestryNavigation = false,
  });

  @override
  State<CupertinoStyleMediaView> createState() => _CupertinoStyleMediaViewState();
}

class _CupertinoStyleMediaViewState extends State<CupertinoStyleMediaView> {
  @override
  void initState() {
    super.initState();

    final ratingKey = widget.media.ratingKey;
    final mediaType = widget.media.mediaType;
    if (ratingKey == null || mediaType == null) {
      di.sl<Logging>().error('Media :: Cannot load media page — ratingKey or mediaType is null for media ${widget.media.title}');
      return;
    }

    final settingsBloc = context.read<SettingsBloc>();

    context.read<MetadataBloc>().add(
      MetadataFetched(
        server: widget.server,
        ratingKey: ratingKey,
        settingsBloc: settingsBloc,
      ),
    );

    context.read<IndividualHistoryBloc>().add(
      IndividualHistoryFetched(
        server: widget.server,
        ratingKey: ratingKey,
        mediaType: mediaType,
        settingsBloc: settingsBloc,
      ),
    );

    if ([
      MediaType.show,
      MediaType.artist,
      MediaType.album,
      MediaType.season,
      MediaType.photoAlbum,
    ].contains(mediaType)) {
      context.read<ChildrenMetadataBloc>().add(
        ChildrenMetadataFetched(
          server: widget.server,
          ratingKey: ratingKey,
          settingsBloc: settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.media.mediaType) {
      case MediaType.album:
        return CupertinoStyleAlbumMediaPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.artist:
        return CupertinoStyleArtistMediaPage(
          server: widget.server,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.clip:
        return CupertinoStyleClipMediaPage(
          server: widget.server,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.episode:
        return CupertinoStyleEpisodeMediaPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
          parentPosterUri: widget.parentPosterUri,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.photo:
        return CupertinoStylePhotoMediaPage(
          server: widget.server,
          media: widget.media,
          disableAppBarActions: widget.disableAppBarActions,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.photoAlbum:
        return CupertinoStylePhotoAlbumMediaPage(
          server: widget.server,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.season:
        return CupertinoStyleSeasonMediaPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.show:
        return CupertinoStyleShowMediaPage(
          server: widget.server,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.track:
        return CupertinoStyleTrackMediaPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
      case MediaType.movie:
      case MediaType.otherVideo:
      default:
        return CupertinoStyleMovieMediaPage(
          server: widget.server,
          media: widget.media,
          previousPageTitle: widget.previousPageTitle,
        );
    }
  }
}
