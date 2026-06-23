import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/types/media_type.dart';
import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';

class MaterialStyleRecentlyAddedFilterBottomSheet extends StatelessWidget {
  final MediaType? mediaType;

  const MaterialStyleRecentlyAddedFilterBottomSheet({
    super.key,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.filter_recently_added_title.tr(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterTile(
              title: LocaleKeys.all_title.tr(),
              selected: mediaType == null,
              onTap: () => Navigator.of(context).pop((mediaType: null)),
            ),
            _FilterTile(
              title: LocaleKeys.movies_title.tr(),
              selected: mediaType == MediaType.movie,
              onTap: () => Navigator.of(context).pop((mediaType: MediaType.movie)),
            ),
            _FilterTile(
              title: LocaleKeys.tv_shows_title.tr(),
              selected: mediaType == MediaType.show,
              onTap: () => Navigator.of(context).pop((mediaType: MediaType.show)),
            ),
            _FilterTile(
              title: LocaleKeys.music_title.tr(),
              selected: mediaType == MediaType.artist,
              onTap: () => Navigator.of(context).pop((mediaType: MediaType.artist)),
            ),
            _FilterTile(
              title: LocaleKeys.videos_title.tr(),
              selected: mediaType == MediaType.otherVideo,
              onTap: () => Navigator.of(context).pop((mediaType: MediaType.otherVideo)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _FilterTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ElevationOverlay.applySurfaceTint(
        Theme.of(context).colorScheme.surface,
        Theme.of(context).colorScheme.surfaceTint,
        1,
      ),
      child: ListTile(
        title: Text(title),
        trailing: selected
            ? Icon(
                Icons.check_rounded,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
