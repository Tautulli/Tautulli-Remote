import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class MaterialStyleServerTimeoutBottomSheet extends StatelessWidget {
  final int initialValue;

  const MaterialStyleServerTimeoutBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    void valueChanged(int value) {
      context.read<SettingsBloc>().add(SettingsUpdateServerTimeout(value));
      Navigator.of(context).pop();
    }

    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.server_timeout_title.tr(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SelectTile(
              title: '3 ${LocaleKeys.sec.tr()}',
              selected: initialValue == 3,
              onTap: () => valueChanged(3),
            ),
            _SelectTile(
              title: '5 ${LocaleKeys.sec.tr()}',
              selected: initialValue == 5,
              onTap: () => valueChanged(5),
            ),
            _SelectTile(
              title: '8 ${LocaleKeys.sec.tr()}',
              selected: initialValue == 8,
              onTap: () => valueChanged(8),
            ),
            _SelectTile(
              title: '15 ${LocaleKeys.sec.tr()} (${LocaleKeys.default_title.tr()})',
              selected: initialValue == 15,
              onTap: () => valueChanged(15),
            ),
            _SelectTile(
              title: '30 ${LocaleKeys.sec.tr()}',
              selected: initialValue == 30,
              onTap: () => valueChanged(30),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _SelectTile({
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
