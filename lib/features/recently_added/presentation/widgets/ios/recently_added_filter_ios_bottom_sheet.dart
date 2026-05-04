import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';

class RecentlyAddedFilterIosBottomSheet extends StatelessWidget {
  final MediaType? mediaType;

  const RecentlyAddedFilterIosBottomSheet({
    super.key,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      //TODO: Add translation string
      middle: const Text('Filter Recently Added'),
      showBackButton: false,
      leading: const IosBottomSheetCancelButton(),
      child: SingleChildScrollView(
        child: CustomCupertinoListSection(
          hasLeading: false,
          children: [
            CustomNotchedCupertinoListTile(
              onTap: () => Navigator.of(context).pop(null),
              titleText: LocaleKeys.all_title.tr(),
              trailing: mediaType == null ? const Icon(CupertinoIcons.checkmark_alt) : null,
            ),
            CustomNotchedCupertinoListTile(
              onTap: () => Navigator.of(context).pop(MediaType.movie),
              titleText: LocaleKeys.movies_title.tr(),
              trailing: mediaType == MediaType.movie ? const Icon(CupertinoIcons.checkmark_alt) : null,
            ),
            CustomNotchedCupertinoListTile(
              onTap: () => Navigator.of(context).pop(MediaType.show),
              titleText: LocaleKeys.tv_shows_title.tr(),
              trailing: mediaType == MediaType.show ? const Icon(CupertinoIcons.checkmark_alt) : null,
            ),
            CustomNotchedCupertinoListTile(
              onTap: () => Navigator.of(context).pop(MediaType.artist),
              titleText: LocaleKeys.music_title.tr(),
              trailing: mediaType == MediaType.artist ? const Icon(CupertinoIcons.checkmark_alt) : null,
            ),
            CustomNotchedCupertinoListTile(
              onTap: () => Navigator.of(context).pop(MediaType.otherVideo),
              titleText: LocaleKeys.videos_title.tr(),
              trailing: mediaType == MediaType.otherVideo ? const Icon(CupertinoIcons.checkmark_alt) : null,
            ),
          ],
        ),
      ),
    );
  }
}
