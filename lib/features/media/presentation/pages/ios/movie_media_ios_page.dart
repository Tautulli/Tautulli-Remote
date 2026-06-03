import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/widgets/ios/ios_poster.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/media_model.dart';
import '../../widgets/ios/media_details_ios_tab.dart';
import '../../widgets/ios/media_history_ios_tab.dart';
import 'tabbed_poster_details_ios_page.dart';

class MovieMediaIosPage extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final String previousPageTitle;

  const MovieMediaIosPage({
    super.key,
    required this.server,
    required this.media,
    required this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return MovieMediaIosView(
      server: server,
      media: media,
      previousPageTitle: previousPageTitle,
    );
  }
}

class MovieMediaIosView extends StatelessWidget {
  final ServerModel server;
  final MediaModel media;
  final String previousPageTitle;
  final bool disableAncestryNavigation;

  const MovieMediaIosView({
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
          poster: IosPoster(
            mediaType: media.mediaType,
            uri: media.imageUri,
          ),
          itemTitle: media.title,
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
}
