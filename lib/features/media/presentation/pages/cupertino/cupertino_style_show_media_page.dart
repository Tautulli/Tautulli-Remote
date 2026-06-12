import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_poster.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/media_model.dart';
import '../../widgets/cupertino/cupertino_style_media_children_tab.dart';
import '../../widgets/cupertino/cupertino_style_media_details_tab.dart';
import '../../widgets/cupertino/cupertino_style_media_history_tab.dart';
import 'cupertino_style_tabbed_poster_details_page.dart';

class CupertinoStyleShowMediaPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final String? previousPageTitle;

  const CupertinoStyleShowMediaPage({
    super.key,
    required this.server,
    required this.media,
    required this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleShowMediaView(
      server: server,
      media: media,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStyleShowMediaView extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final String? previousPageTitle;
  final bool disableAncestryNavigation;

  const CupertinoStyleShowMediaView({
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
          background: ImageGradientBackground(
            imageUri: media.imageUri,
            httpHeaders: {
              for (CustomHeaderModel headerModel in settingsState.appSettings.activeServer.customHeaders)
                headerModel.key: headerModel.value,
            },
          ),
          poster: CupertinoStylePoster(
            mediaType: media.mediaType,
            uri: media.imageUri,
          ),
          itemTitle: media.title,
          itemSubtitle: media.year?.toString(),
          segments: {
            0: const Text(LocaleKeys.details_title).tr(),
            1: const Text(LocaleKeys.seasons_title).tr(),
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
}
