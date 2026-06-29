import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_poster.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/media_model.dart';
import '../../bloc/metadata_bloc.dart';
import '../../widgets/cupertino/bottom_sheets/cupertino_style_media_navigate_bottom_sheet.dart';
import '../../widgets/cupertino/cupertino_style_media_details_tab.dart';
import '../../widgets/cupertino/cupertino_style_media_history_tab.dart';
import 'cupertino_style_tabbed_poster_details_page.dart';

class CupertinoStyleEpisodeMediaPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final Uri? parentPosterUri;
  final bool disableAncestryNavigation;
  final String? previousPageTitle;

  const CupertinoStyleEpisodeMediaPage({
    super.key,
    required this.server,
    required this.media,
    this.parentPosterUri,
    this.disableAncestryNavigation = false,
    required this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleEpisodeMediaView(
      server: server,
      media: media,
      parentPosterUri: parentPosterUri,
      disableAncestryNavigation: disableAncestryNavigation,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStyleEpisodeMediaView extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final Uri? parentPosterUri;
  final bool disableAncestryNavigation;
  final String? previousPageTitle;

  const CupertinoStyleEpisodeMediaView({
    super.key,
    required this.server,
    required this.media,
    this.parentPosterUri,
    this.disableAncestryNavigation = false,
    required this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        settingsState as SettingsSuccess;

        return CupertinoStyleTabbedPosterDetailsPage(
          previousPageTitle: previousPageTitle,
          background: ImageGradientBackground(
            imageUri: media.imageUri,
            httpHeaders: {
              for (CustomHeaderModel headerModel in settingsState.appSettings.activeServer.customHeaders)
                headerModel.key: headerModel.value,
            },
          ),
          navBarActions: _navBarActions(context),
          poster: CupertinoStylePoster(
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
            CupertinoStyleMediaDetailsTab(
              server: server,
              ratingKey: media.ratingKey!,
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
            child: const Icon(
              CupertinoIcons.arrow_turn_left_up,
              color: ThemeHelper.cupertinoNavigationBarItemColor,
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
