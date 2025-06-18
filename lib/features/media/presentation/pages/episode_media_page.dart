import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/open_in_plex/open_in_plex.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/poster.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/data/models/custom_header_model.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/media_model.dart';
import '../bloc/metadata_bloc.dart';
import '../widgets/media_details_tab.dart';
import '../widgets/media_history_tab.dart';
import 'media_page.dart';
import 'sliver_tabbed_poster_details_page.dart';

class EpisodeMediaPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final Uri? parentPosterUri;
  final bool disableAncestryNavigation;

  const EpisodeMediaPage({
    super.key,
    required this.server,
    required this.media,
    this.parentPosterUri,
    this.disableAncestryNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    return EpisodeMediaView(
      server: server,
      media: media,
      parentPosterUri: parentPosterUri,
      disableAncestryNavigation: disableAncestryNavigation,
    );
  }
}

class EpisodeMediaView extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final Uri? parentPosterUri;
  final bool disableAncestryNavigation;

  const EpisodeMediaView({
    super.key,
    required this.server,
    required this.media,
    this.parentPosterUri,
    this.disableAncestryNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliverTabbedPosterDetailsPage(
        background: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return CachedNetworkImage(
              imageUrl: media.imageUri.toString(),
              httpHeaders: {
                for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders) headerModel.key: headerModel.value,
              },
              imageBuilder: (context, imageProvider) => ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                  tileMode: TileMode.decal,
                ),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
              placeholder: (context, url) => Image.asset('assets/images/art_fallback.png'),
              errorWidget: (context, url, error) => Image.asset('assets/images/art_error.png'),
            );
          },
        ),
        appBarActions: _appBarActions(context),
        poster: Poster(
          heroTag: media.ratingKey,
          mediaType: media.mediaType,
          uri: parentPosterUri ?? media.imageUri,
        ),
        pageTitle: media.title,
        itemTitle: media.grandparentTitle,
        itemSubtitle: media.title ?? '',
        itemDetail: media.parentMediaIndex != null && media.mediaIndex != null ? 'S${media.parentMediaIndex} • E${media.mediaIndex}' : null,
        tabs: [
          Tab(child: const Text(LocaleKeys.details_title).tr()),
          Tab(child: const Text(LocaleKeys.history_title).tr()),
        ],
        tabChildren: [
          MediaDetailsTab(
            server: server,
            ratingKey: media.ratingKey!,
          ),
          MediaHistoryTab(
            server: server,
            ratingKey: media.ratingKey!,
            mediaType: media.mediaType!,
            parentPosterUri: media.imageUri,
          ),
        ],
      ),
    );
  }

  List<Widget> _appBarActions(BuildContext context) {
    return [
      BlocBuilder<MetadataBloc, MetadataState>(
        builder: (context, state) {
          return PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            onSelected: (value) async {
              if (value == MediaType.show) {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MediaPage(
                      server: server,
                      media: media.copyWith(
                        title: state.metadata!.grandparentTitle,
                        mediaType: MediaType.show,
                        ratingKey: state.metadata!.grandparentRatingKey,
                        imageUri: state.metadata!.grandparentImageUri,
                      ),
                    ),
                  ),
                );
              }

              if (value == MediaType.season) {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MediaPage(
                      server: server,
                      media: media.copyWith(
                        parentTitle: state.metadata!.grandparentTitle,
                        title: state.metadata!.parentTitle,
                        mediaType: MediaType.season,
                        ratingKey: state.metadata!.parentRatingKey,
                        imageUri: state.metadata!.parentImageUri,
                      ),
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  enabled: !disableAncestryNavigation,
                  value: MediaType.show,
                  child: const Text(LocaleKeys.go_to_show_title).tr(),
                ),
                PopupMenuItem(
                  enabled: !disableAncestryNavigation,
                  value: MediaType.season,
                  child: const Text(LocaleKeys.go_to_season_title).tr(),
                ),
                // PopupMenuItem(
                //   child: const Text(LocaleKeys.view_on_plex_title).tr(),
                //   onTap: () async {
                //     await di.sl<OpenInPlex>().open(
                //           plexIdentifier: server.plexIdentifier,
                //           ratingKey: media.ratingKey!,
                //         );
                //   },
                // ),
              ];
            },
          );
        },
      ),
    ];
  }
}
