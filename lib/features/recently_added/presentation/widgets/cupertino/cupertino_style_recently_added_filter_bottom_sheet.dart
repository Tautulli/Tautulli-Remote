import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../translations/locale_keys.g.dart';

class CupertinoStyleRecentlyAddedFilterBottomSheet extends StatelessWidget {
  final MediaType? mediaType;

  const CupertinoStyleRecentlyAddedFilterBottomSheet({
    super.key,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleModalPopupScaffold(
      //TODO: Add translation string
      middleText: 'Filter Recently Added',
      leading: const CupertinoStyleBottomSheetCancelButton(),
      child: CupertinoStyleListSection(
        hasLeading: false,
        children: [
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => Navigator.of(context).pop(null),
            titleText: LocaleKeys.all_title.tr(),
            trailing: mediaType == null ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => Navigator.of(context).pop(MediaType.movie),
            titleText: LocaleKeys.movies_title.tr(),
            trailing: mediaType == MediaType.movie ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => Navigator.of(context).pop(MediaType.show),
            titleText: LocaleKeys.tv_shows_title.tr(),
            trailing: mediaType == MediaType.show ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => Navigator.of(context).pop(MediaType.artist),
            titleText: LocaleKeys.music_title.tr(),
            trailing: mediaType == MediaType.artist ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () => Navigator.of(context).pop(MediaType.otherVideo),
            titleText: LocaleKeys.videos_title.tr(),
            trailing: mediaType == MediaType.otherVideo ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
