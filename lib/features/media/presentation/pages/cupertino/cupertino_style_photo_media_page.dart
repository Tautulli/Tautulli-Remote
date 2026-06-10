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
import '../../widgets/cupertino/cupertino_style_media_details_tab.dart';
import 'cupertino_style_tabbed_poster_details_page.dart';

class CupertinoStylePhotoMediaPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final bool disableAppBarActions;
  final String? previousPageTitle;

  const CupertinoStylePhotoMediaPage({
    super.key,
    required this.server,
    required this.media,
    this.disableAppBarActions = false,
    required this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStylePhotoMediaView(
      server: server,
      media: media,
      disableAppBarActions: disableAppBarActions,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStylePhotoMediaView extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final String? previousPageTitle;
  final bool disableAppBarActions;

  const CupertinoStylePhotoMediaView({
    super.key,
    required this.server,
    required this.media,
    required this.previousPageTitle,
    this.disableAppBarActions = false,
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
          itemSubtitle: media.parentTitle ?? '',
          segments: {
            0: const Text(LocaleKeys.details_title).tr(),
          },
          segmentChildren: [
            CupertinoStyleMediaDetailsTab(
              server: server,
              ratingKey: media.ratingKey!,
            ),
          ],
        );
      },
    );
  }
}
