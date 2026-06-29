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
import 'cupertino_style_tabbed_poster_details_page.dart';

class CupertinoStylePhotoAlbumMediaPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final String? previousPageTitle;

  const CupertinoStylePhotoAlbumMediaPage({
    super.key,
    required this.server,
    required this.media,
    required this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStylePhotoAlbumMediaView(
      server: server,
      media: media,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStylePhotoAlbumMediaView extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final String? previousPageTitle;
  final bool disableAncestryNavigation;

  const CupertinoStylePhotoAlbumMediaView({
    super.key,
    required this.server,
    required this.media,
    required this.previousPageTitle,
    this.disableAncestryNavigation = false,
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
          poster: CupertinoStylePoster(
            mediaType: media.mediaType,
            uri: media.imageUri,
          ),
          itemTitle: media.title,
          segments: {
            0: const Text(LocaleKeys.media_title).tr(),
          },
          segmentChildren: [
            CupertinoStyleMediaChildrenTab(
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
