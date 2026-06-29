import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';

class MaterialStyleHistoryFilterBottomSheet extends StatefulWidget {
  final Map<String, bool> filterMap;

  const MaterialStyleHistoryFilterBottomSheet({
    super.key,
    required this.filterMap,
  });

  @override
  State<MaterialStyleHistoryFilterBottomSheet> createState() => _MaterialStyleHistoryFilterBottomSheetState();
}

class _MaterialStyleHistoryFilterBottomSheetState extends State<MaterialStyleHistoryFilterBottomSheet> {
  late Map<String, bool> _filterMap;

  @override
  void initState() {
    super.initState();
    _filterMap = Map<String, bool>.from(widget.filterMap);
  }

  void _toggle(String key, bool value) {
    setState(() {
      _filterMap[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.filter_history_title.tr(),
      leading: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
      trailing: TextButton(
        onPressed: () => Navigator.of(context).pop(Map<String, bool>.from(_filterMap)),
        child: const Text(LocaleKeys.save_title).tr(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FilterTile(
                  title: LocaleKeys.movies_title.tr(),
                  value: _filterMap['movie'] ?? true,
                  onTap: () => _toggle('movie', !(_filterMap['movie'] ?? true)),
                ),
                _FilterTile(
                  title: LocaleKeys.tv_shows_title.tr(),
                  value: _filterMap['episode'] ?? true,
                  onTap: () => _toggle('episode', !(_filterMap['episode'] ?? true)),
                ),
                _FilterTile(
                  title: LocaleKeys.music_title.tr(),
                  value: _filterMap['track'] ?? true,
                  onTap: () => _toggle('track', !(_filterMap['track'] ?? true)),
                ),
                _FilterTile(
                  title: LocaleKeys.live_tv_title.tr(),
                  value: _filterMap['live'] ?? true,
                  onTap: () => _toggle('live', !(_filterMap['live'] ?? true)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FilterTile(
                  title: LocaleKeys.direct_play_title.tr(),
                  value: _filterMap['directPlay'] ?? true,
                  onTap: () => _toggle('directPlay', !(_filterMap['directPlay'] ?? true)),
                ),
                _FilterTile(
                  title: LocaleKeys.direct_stream_title.tr(),
                  value: _filterMap['directStream'] ?? true,
                  onTap: () => _toggle('directStream', !(_filterMap['directStream'] ?? true)),
                ),
                _FilterTile(
                  title: LocaleKeys.transcode_title.tr(),
                  value: _filterMap['transcode'] ?? true,
                  onTap: () => _toggle('transcode', !(_filterMap['transcode'] ?? true)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  final String title;
  final bool value;
  final VoidCallback onTap;

  const _FilterTile({
    required this.title,
    required this.value,
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
        trailing: value
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
