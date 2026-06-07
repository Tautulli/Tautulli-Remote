import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_poster.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/media_model.dart';
import '../../bloc/metadata_bloc.dart';
import '../../widgets/cupertino/cupertino_style_media_children_tab.dart';
import '../../widgets/cupertino/cupertino_style_media_details_tab.dart';
import '../../widgets/cupertino/cupertino_style_media_history_tab.dart';
import '../../widgets/cupertino/bottom_sheets/cupertino_style_media_navigate_bottom_sheet.dart';
import 'cupertino_style_tabbed_poster_details_page.dart';

class CupertinoStyleSeasonMediaPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final bool disableAncestryNavigation;
  final String? previousPageTitle;

  const CupertinoStyleSeasonMediaPage({
    super.key,
    required this.server,
    required this.media,
    this.disableAncestryNavigation = false,
    required this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleSeasonMediaView(
      server: server,
      media: media,
      disableAncestryNavigation: disableAncestryNavigation,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStyleSeasonMediaView extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final String? previousPageTitle;
  final bool disableAncestryNavigation;

  const CupertinoStyleSeasonMediaView({
    super.key,
    required this.server,
    required this.media,
    required this.previousPageTitle,
    this.disableAncestryNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        settingsState as SettingsSuccess;

        return CupertinoStyleTabbedPosterDetailsPage(
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
          poster: CupertinoStylePoster(
            mediaType: media.mediaType,
            uri: media.imageUri,
          ),
          itemTitle: media.parentTitle,
          itemSubtitle: media.title,
          segments: {
            0: const Text(LocaleKeys.details_title).tr(),
            1: const Text(LocaleKeys.episodes_title).tr(),
            2: const Text(LocaleKeys.history_title).tr(),
          },
          segmentChildren: [
            CupertinoStyleMediaDetailsTab(
              server: server,
              ratingKey: media.ratingKey!,
            ),
            CupertinoStyleMediaChildrenTab(
              server: server,
              ratingKey: media.ratingKey!,
              mediaType: media.mediaType!,
              parentPosterUri: media.imageUri,
            ),
            CupertinoStyleMediaHistoryTab(
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
                child: CupertinoStyleMediaNavigateBottomSheet(
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
