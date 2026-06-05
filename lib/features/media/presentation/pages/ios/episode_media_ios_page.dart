import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/ios/ios_poster.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/media_model.dart';
import '../../bloc/metadata_bloc.dart';
import '../../widgets/ios/media_details_ios_tab.dart';
import '../../widgets/ios/media_history_ios_tab.dart';
import '../../widgets/ios/media_navigate_ios_bottom_sheet.dart';
import 'tabbed_poster_details_ios_page.dart';

class EpisodeMediaIosPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final Uri? parentPosterUri;
  final bool disableAncestryNavigation;
  final String? previousPageTitle;

  const EpisodeMediaIosPage({
    super.key,
    required this.server,
    required this.media,
    this.parentPosterUri,
    this.disableAncestryNavigation = false,
    required this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return EpisodeMediaIosView(
      server: server,
      media: media,
      parentPosterUri: parentPosterUri,
      disableAncestryNavigation: disableAncestryNavigation,
      previousPageTitle: previousPageTitle,
    );
  }
}

class EpisodeMediaIosView extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final Uri? parentPosterUri;
  final bool disableAncestryNavigation;
  final String? previousPageTitle;

  const EpisodeMediaIosView({
    super.key,
    required this.server,
    required this.media,
    this.parentPosterUri,
    this.disableAncestryNavigation = false,
    required this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        settingsState as SettingsSuccess;

        return TabbedPosterDetailsIosPage(
          previousPageTitle: previousPageTitle,
          background: CachedNetworkImage(
            imageUrl: media.imageUri.toString(),
            httpHeaders: {
              for (CustomHeaderModel headerModel in settingsState.appSettings.activeServer.customHeaders)
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
          ),
          navBarActions: _navBarActions(context),
          poster: IosPoster(
            mediaType: media.mediaType,
            uri: parentPosterUri ?? media.imageUri,
          ),
          itemTitle: media.grandparentTitle,
          itemSubtitle: media.title ?? '',
          itemDetail: media.parentMediaIndex != null && media.mediaIndex != null
              ? 'S${media.parentMediaIndex} • E${media.mediaIndex}'
              : null,
          segments: {
            0: const Text(LocaleKeys.details_title).tr(),
            1: const Text(LocaleKeys.history_title).tr(),
          },
          segmentChildren: [
            MediaDetailsIosTab(
              server: server,
              ratingKey: media.ratingKey!,
            ),

            MediaHistoryIosTab(
              server: server,
              ratingKey: media.ratingKey!,
              mediaType: media.mediaType!,
              parentPosterUri: media.imageUri,
            ),
          ],
        );
      },
    );
  }

  Widget _navBarActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!disableAncestryNavigation)
          CupertinoButton(
            padding: const EdgeInsets.all(8),
            child: Icon(
              CupertinoIcons.arrow_turn_left_up,
              color: ThemeHelper.cupertinoNavigationBarItemColor(),
            ),
            onPressed: () => showCupertinoModalPopup(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<MetadataBloc>(),
                child: MediaNavigateIosBottomSheet(
                  mediaType: media.mediaType,
                  server: server,
                  media: media,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
