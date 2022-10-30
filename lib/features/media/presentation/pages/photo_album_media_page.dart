import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/open_in_plex/open_in_plex.dart';
import '../../../../core/widgets/poster.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/data/models/custom_header_model.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/media_model.dart';
import '../widgets/media_children_tab.dart';
import 'sliver_tabbed_poster_details_page.dart';

class PhotoAlbumMediaPage extends StatelessWidget {
  final MediaModel media;
  final String plexIdentifier;

  const PhotoAlbumMediaPage({
    super.key,
    required this.media,
    required this.plexIdentifier,
  });

  @override
  Widget build(BuildContext context) {
    return PhotoAlbumMediaView(
      media: media,
      plexIdentifier: plexIdentifier,
    );
  }
}

class PhotoAlbumMediaView extends StatelessWidget {
  final MediaModel media;
  final String plexIdentifier;

  const PhotoAlbumMediaView({
    super.key,
    required this.media,
    required this.plexIdentifier,
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
                for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                  headerModel.key: headerModel.value,
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
        appBarActions: _appBarActions(),
        poster: Poster(
          heroTag: media.ratingKey,
          mediaType: media.mediaType,
          uri: media.imageUri,
        ),
        title: media.title,
        tabs: [
          Tab(
            child: const Text(LocaleKeys.media_title).tr(),
          ),
        ],
        tabChildren: [
          MediaChildrenTab(
            ratingKey: media.ratingKey!,
            mediaType: media.mediaType!,
            parentPosterUri: media.imageUri,
          ),
        ],
      ),
    );
  }

  List<Widget> _appBarActions() {
    return [
      PopupMenuButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: const Text(LocaleKeys.view_on_plex_title).tr(),
              onTap: () async {
                await di.sl<OpenInPlex>().open(
                      plexIdentifier: plexIdentifier,
                      ratingKey: media.ratingKey!,
                      useLegacy: true,
                    );
              },
            ),
          ];
        },
      ),
    ];
  }
}
