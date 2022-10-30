import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/open_in_plex/open_in_plex.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/poster.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/data/models/custom_header_model.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/media_model.dart';
import '../widgets/media_details_tab.dart';
import '../widgets/media_history_tab.dart';
import 'sliver_tabbed_poster_details_page.dart';

class ClipMediaPage extends StatelessWidget {
  final MediaModel media;
  final String plexIdentifier;

  const ClipMediaPage({
    super.key,
    required this.media,
    required this.plexIdentifier,
  });

  @override
  Widget build(BuildContext context) {
    return ClipMediaView(
      media: media,
      plexIdentifier: plexIdentifier,
    );
  }
}

class ClipMediaView extends StatelessWidget {
  final MediaModel media;
  final String plexIdentifier;

  const ClipMediaView({
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
        subtitle: media.parentTitle ?? '',
        tabs: [
          Tab(child: const Text(LocaleKeys.details_title).tr()),
        ],
        tabChildren: [
          MediaDetailsTab(
            ratingKey: media.ratingKey!,
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
                      ratingKey: media.parentRatingKey!,
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
