import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/types/media_type.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';

class CupertinoStyleRecentlyAddedFilterBottomSheet extends StatelessWidget {
  final MediaType? mediaType;

  const CupertinoStyleRecentlyAddedFilterBottomSheet({
    super.key,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return CupertinoStyleModalPopupScaffold(
      middleText: LocaleKeys.filter_recently_added_title.tr(),
      leading: const CupertinoStyleBottomSheetCancelButton(),
      child: CupertinoStyleListSection(
        hasLeading: false,
        children: [
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => Navigator.of(context).pop((mediaType: null)),
            titleText: LocaleKeys.all_title.tr(),
            trailing: mediaType == null ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => Navigator.of(context).pop((mediaType: MediaType.movie)),
            titleText: LocaleKeys.movies_title.tr(),
            trailing: mediaType == MediaType.movie ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => Navigator.of(context).pop((mediaType: MediaType.show)),
            titleText: LocaleKeys.tv_shows_title.tr(),
            trailing: mediaType == MediaType.show ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => Navigator.of(context).pop((mediaType: MediaType.artist)),
            titleText: LocaleKeys.music_title.tr(),
            trailing: mediaType == MediaType.artist ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => Navigator.of(context).pop((mediaType: MediaType.otherVideo)),
            titleText: LocaleKeys.videos_title.tr(),
            trailing: mediaType == MediaType.otherVideo ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
