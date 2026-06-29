import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';

class MaterialStyleUsersSortBottomSheet extends StatefulWidget {
  final String orderColumn;
  final String orderDir;

  const MaterialStyleUsersSortBottomSheet({
    super.key,
    required this.orderColumn,
    required this.orderDir,
  });

  @override
  State<MaterialStyleUsersSortBottomSheet> createState() => _MaterialStyleUsersSortBottomSheetState();
}

class _MaterialStyleUsersSortBottomSheetState extends State<MaterialStyleUsersSortBottomSheet> {
  late String _orderColumn;
  late String _orderDir;

  @override
  void initState() {
    super.initState();
    _orderColumn = widget.orderColumn;
    _orderDir = widget.orderDir;
  }

  void _changeSort(String column) {
    setState(() {
      if (_orderColumn == column) {
        _orderDir = _orderDir == 'asc' ? 'desc' : 'asc';
      } else {
        _orderColumn = column;
        _orderDir = 'asc';
      }
    });
  }

  Widget _sortIndicators(String column) {
    final isActive = _orderColumn == column;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(
          FontAwesomeIcons.arrowDown,
          size: 14,
          color: isActive && _orderDir == 'asc'
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        const SizedBox(width: 4),
        FaIcon(
          FontAwesomeIcons.arrowUp,
          size: 14,
          color: isActive && _orderDir == 'desc'
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.sort_users_title.tr(),
      leading: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
      trailing: TextButton(
        onPressed: () => Navigator.of(context).pop({
          'orderColumn': _orderColumn,
          'orderDir': _orderDir,
        }),
        child: const Text(LocaleKeys.save_title).tr(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SortTile(
              title: LocaleKeys.name_title.tr(),
              trailing: _sortIndicators('friendly_name'),
              onTap: () => _changeSort('friendly_name'),
            ),
            _SortTile(
              title: LocaleKeys.last_streamed_title.tr(),
              trailing: _sortIndicators('last_seen'),
              onTap: () => _changeSort('last_seen'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortTile extends StatelessWidget {
  final String title;
  final Widget trailing;
  final VoidCallback onTap;

  const _SortTile({
    required this.title,
    required this.trailing,
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
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
