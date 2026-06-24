import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/types/play_metric_type.dart';
import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';

class MaterialStyleYAxisTypeBottomSheet extends StatelessWidget {
  final PlayMetricType initialValue;

  const MaterialStyleYAxisTypeBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.y_axis_title.tr(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SelectTile(
              icon: const FaIcon(FontAwesomeIcons.hashtag, size: 18),
              title: LocaleKeys.play_count_title.tr(),
              selected: initialValue == PlayMetricType.plays,
              onTap: () => Navigator.of(context).pop(PlayMetricType.plays),
            ),
            _SelectTile(
              icon: const FaIcon(FontAwesomeIcons.solidClock, size: 18),
              title: LocaleKeys.play_time_title.tr(),
              selected: initialValue == PlayMetricType.time,
              onTap: () => Navigator.of(context).pop(PlayMetricType.time),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _SelectTile({
    required this.icon,
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
        leading: icon,
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
