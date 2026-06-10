import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../history/presentation/bloc/individual_history_bloc.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/media_model.dart';
import '../../bloc/children_metadata_bloc.dart';
import '../../bloc/metadata_bloc.dart';
import 'material_style_album_media_page.dart';
import 'material_style_artist_media_page.dart';
import 'material_style_clip_media_page.dart';
import 'material_style_episode_media_page.dart';
import 'material_style_movie_media_page.dart';
import 'material_style_photo_album_media_page.dart';
import 'material_style_photo_media_page.dart';
import 'material_style_season_media_page.dart';
import 'material_style_show_media_page.dart';
import 'material_style_track_media_page.dart';

class MaterialStyleMediaPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final Uri? parentPosterUri;
  final bool disableAppBarActions;
  final bool disableAncestryNavigation;

  const MaterialStyleMediaPage({
    super.key,
    required this.server,
    required this.media,
    this.parentPosterUri,
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
      child: MaterialStyleMediaView(
        server: server,
        media: media,
        parentPosterUri: parentPosterUri,
        disableAppBarActions: disableAppBarActions,
        disableAncestryNavigation: disableAncestryNavigation,
      ),
    );
  }
}

class MaterialStyleMediaView extends StatefulWidget {
  final ServerModel server;
  final MediaModel media;
  final Uri? parentPosterUri;
  final bool disableAppBarActions;
  final bool disableAncestryNavigation;

  const MaterialStyleMediaView({
    super.key,
    required this.server,
    required this.media,
    this.parentPosterUri,
    this.disableAppBarActions = false,
    this.disableAncestryNavigation = false,
  });

  @override
  State<MaterialStyleMediaView> createState() => _MaterialStyleMediaViewState();
}

class _MaterialStyleMediaViewState extends State<MaterialStyleMediaView> {
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
        return MaterialStyleAlbumMediaPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
        );
      case MediaType.artist:
        return MaterialStyleArtistMediaPage(
          server: widget.server,
          media: widget.media,
        );
      case MediaType.clip:
        return MaterialStyleClipMediaPage(
          server: widget.server,
          media: widget.media,
        );
      case MediaType.episode:
        return MaterialStyleEpisodeMediaPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
          parentPosterUri: widget.parentPosterUri,
        );
      case MediaType.photo:
        return MaterialStylePhotoMediaPage(
          server: widget.server,
          media: widget.media,
          disableAppBarActions: widget.disableAppBarActions,
        );
      case MediaType.photoAlbum:
        return MaterialStylePhotoAlbumMediaPage(
          server: widget.server,
          media: widget.media,
        );
      case MediaType.season:
        return MaterialStyleSeasonMediaPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
        );
      case MediaType.show:
        return MaterialStyleSeasonMediaPage(
          server: widget.server,
          media: widget.media,
        );
      case MediaType.track:
        return MaterialStyleTrackMediaPage(
          server: widget.server,
          disableAncestryNavigation: widget.disableAncestryNavigation,
          media: widget.media,
        );
      case MediaType.movie:
      case MediaType.otherVideo:
      default:
        return MaterialStyleMovieMediaPage(
          server: widget.server,
          media: widget.media,
        );
    }
  }
}
