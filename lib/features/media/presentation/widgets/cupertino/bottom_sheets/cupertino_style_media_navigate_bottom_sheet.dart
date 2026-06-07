import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/types/media_type.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../data/models/media_model.dart';
import '../../../bloc/metadata_bloc.dart';
import '../../../pages/cupertino/cupertino_style_media_page.dart';

class CupertinoStyleMediaNavigateBottomSheet extends StatelessWidget {
  final MediaType? mediaType;
  final ServerModel server;
  final MediaModel media;

  const CupertinoStyleMediaNavigateBottomSheet({
    super.key,
    required this.mediaType,
    required this.server,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<MetadataBloc>().state;

    return CupertinoStyleModalPopupScaffold(
      leading: const CupertinoStyleBottomSheetCancelButton(),
      middleText:
          //TODO: Needs translation string
          'Navigate',
      child: CupertinoStyleListSection(
        hasLeading: false,
        children: [
          //* Season
          if (mediaType == MediaType.season)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoStyleNotchedCupertinoListTile(
                  titleText: LocaleKeys.go_to_show_title.tr(),
                  onTap: () async {
                    Navigator.of(context).pop();
                    return await Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => CupertinoStyleMediaPage(
                          server: server,
                          media: media.copyWith(
                            title: state.metadata!.parentTitle,
                            mediaType: MediaType.show,
                            ratingKey: state.metadata!.parentRatingKey,
                            imageUri: state.metadata!.parentImageUri,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          //* Episode
          if (mediaType == MediaType.episode)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoStyleNotchedCupertinoListTile(
                  titleText: LocaleKeys.go_to_show_title.tr(),
                  onTap: () async {
                    Navigator.of(context).pop();
                    return await Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => CupertinoStyleMediaPage(
                          server: server,
                          media: media.copyWith(
                            title: state.metadata!.grandparentTitle,
                            mediaType: MediaType.show,
                            ratingKey: state.metadata!.grandparentRatingKey,
                            imageUri: state.metadata!.grandparentImageUri,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                CupertinoStyleNotchedCupertinoListTile(
                  titleText: LocaleKeys.go_to_season_title.tr(),
                  onTap: () async {
                    Navigator.of(context).pop();
                    return await Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => CupertinoStyleMediaPage(
                          server: server,
                          media: media.copyWith(
                            parentTitle: state.metadata!.grandparentTitle,
                            title: state.metadata!.parentTitle,
                            mediaType: MediaType.season,
                            ratingKey: state.metadata!.parentRatingKey,
                            imageUri: state.metadata!.parentImageUri,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          //* Album
          if (mediaType == MediaType.album)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoStyleNotchedCupertinoListTile(
                  titleText: LocaleKeys.go_to_artist_title.tr(),
                  onTap: () async {
                    Navigator.of(context).pop();
                    return await Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => CupertinoStyleMediaPage(
                          server: server,
                          media: media.copyWith(
                            title: state.metadata!.parentTitle,
                            mediaType: MediaType.artist,
                            ratingKey: state.metadata!.parentRatingKey,
                            imageUri: state.metadata!.parentImageUri,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          //* Track
          if (mediaType == MediaType.track)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoStyleNotchedCupertinoListTile(
                  titleText: LocaleKeys.go_to_artist_title.tr(),
                  onTap: () async {
                    Navigator.of(context).pop();
                    return await Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => CupertinoStyleMediaPage(
                          server: server,
                          media: media.copyWith(
                            title: state.metadata!.grandparentTitle,
                            mediaType: MediaType.artist,
                            ratingKey: state.metadata!.grandparentRatingKey,
                            imageUri: state.metadata!.grandparentImageUri,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                CupertinoStyleNotchedCupertinoListTile(
                  titleText: LocaleKeys.go_to_album_title.tr(),
                  onTap: () async {
                    Navigator.of(context).pop();
                    return await Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => CupertinoStyleMediaPage(
                          server: server,
                          media: media.copyWith(
                            parentTitle: state.metadata!.grandparentTitle,
                            title: state.metadata!.parentTitle,
                            mediaType: MediaType.album,
                            ratingKey: state.metadata!.parentRatingKey,
                            imageUri: state.metadata!.parentImageUri,
                            year: state.metadata!.year,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
