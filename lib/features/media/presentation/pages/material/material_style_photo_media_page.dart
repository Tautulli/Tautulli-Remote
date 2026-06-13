import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../core/widgets/material/material_style_poster.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/media_model.dart';
import '../../widgets/material/material_style_media_details_tab.dart';
import 'material_style_tabbed_poster_details_page.dart';

class MaterialStylePhotoMediaPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final bool disableAppBarActions;

  const MaterialStylePhotoMediaPage({
    super.key,
    required this.server,
    required this.media,
    this.disableAppBarActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialStylePhotoMediaView(
      server: server,
      media: media,
      disableAppBarActions: disableAppBarActions,
    );
  }
}

class MaterialStylePhotoMediaView extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final bool disableAppBarActions;

  const MaterialStylePhotoMediaView({
    super.key,
    required this.server,
    required this.media,
    this.disableAppBarActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialStyleTabbedPosterDetailsPage(
        background: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return ImageGradientBackground(
              imageUri: media.imageUri,
              httpHeaders: {
                for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                  headerModel.key: headerModel.value,
              },
            );
          },
        ),
        // TODO: Re-enable once new plex app deep links are discovered
        // appBarActions: _appBarActions(context),
        poster: MaterialStylePoster(
          heroTag: media.ratingKey,
          mediaType: media.mediaType,
          uri: media.imageUri,
        ),
        pageTitle: media.title,
        itemTitle: media.title,
        itemSubtitle: media.parentTitle,
        tabs: [
          Tab(child: const Text(LocaleKeys.details_title).tr()),
        ],
        tabChildren: [
          MaterialStyleMediaDetailsTab(
            server: server,
            ratingKey: media.ratingKey!,
          ),
        ],
      ),
    );
  }

  // List<Widget> _appBarActions(BuildContext context) {
  //   return [
  //     PopupMenuButton(
  //       icon: Icon(
  //         Icons.more_vert,
  //         color: Theme.of(context).colorScheme.onSurface,
  //       ),
  //       enabled: !disableAppBarActions,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(12),
  //         ),
  //       ),
  //       itemBuilder: (context) {
  //         return [
  //           PopupMenuItem(
  //             child: const Text(LocaleKeys.view_on_plex_title).tr(),
  //             onTap: () async {
  //               await di.sl<OpenInPlex>().open(
  //                 plexIdentifier: server.plexIdentifier,
  //                 ratingKey: media.parentRatingKey!,
  //                 useLegacy: true,
  //               );
  //             },
  //           ),
  //         ];
  //       },
  //     ),
  //   ];
  // }
}
