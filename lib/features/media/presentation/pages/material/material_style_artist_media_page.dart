import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/open_in_plex/open_in_plex.dart';
import '../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../core/widgets/material/material_style_poster.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/media_model.dart';
import '../../widgets/material/material_style_media_children_tab.dart';
import '../../widgets/material/material_style_media_details_tab.dart';
import '../../widgets/material/material_style_media_history_tab.dart';
import 'material_style_tabbed_poster_details_page.dart';

class MaterialStyleArtistMediaPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;

  const MaterialStyleArtistMediaPage({
    super.key,
    required this.server,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialStyleArtistMediaView(
      server: server,
      media: media,
    );
  }
}

class MaterialStyleArtistMediaView extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;

  const MaterialStyleArtistMediaView({
    super.key,
    required this.server,
    required this.media,
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
        tabs: [
          Tab(child: const Text(LocaleKeys.details_title).tr()),
          Tab(
            child: const Text(LocaleKeys.albums_title).tr(),
          ),
          Tab(child: const Text(LocaleKeys.history_title).tr()),
        ],
        tabChildren: [
          MaterialStyleMediaDetailsTab(
            server: server,
            ratingKey: media.ratingKey!,
          ),
          MaterialStyleMediaChildrenTab(
            server: server,
            ratingKey: media.ratingKey!,
            mediaType: media.mediaType!,
            parentPosterUri: media.imageUri,
          ),
          MaterialStyleMediaHistoryTab(
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
      PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).colorScheme.onSurface,
        ),
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
                  plexIdentifier: server.plexIdentifier,
                  ratingKey: media.ratingKey!,
                );
              },
            ),
          ];
        },
      ),
    ];
  }
}
