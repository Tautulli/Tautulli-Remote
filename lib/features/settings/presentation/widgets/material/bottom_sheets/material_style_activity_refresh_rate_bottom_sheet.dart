import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class MaterialStyleActivityRefreshRateBottomSheet extends StatelessWidget {
  final int initialValue;

  const MaterialStyleActivityRefreshRateBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    void valueChanged(int value) {
      context.read<SettingsBloc>().add(SettingsUpdateRefreshRate(value));
      Navigator.of(context).pop();
    }

    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.activity_refresh_rate_title.tr(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SelectTile(
              title: '5 ${LocaleKeys.sec.tr()} - ${LocaleKeys.faster_title.tr()}',
              selected: initialValue == 5,
              onTap: () => valueChanged(5),
            ),
            _SelectTile(
              title: '7 ${LocaleKeys.sec.tr()} - ${LocaleKeys.fast_title.tr()}',
              selected: initialValue == 7,
              onTap: () => valueChanged(7),
            ),
            _SelectTile(
              title: '10 ${LocaleKeys.sec.tr()} - ${LocaleKeys.normal_title.tr()}',
              selected: initialValue == 10,
              onTap: () => valueChanged(10),
            ),
            _SelectTile(
              title: '15 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slow_title.tr()}',
              selected: initialValue == 15,
              onTap: () => valueChanged(15),
            ),
            _SelectTile(
              title: '20 ${LocaleKeys.sec.tr()} - ${LocaleKeys.slower_title.tr()}',
              selected: initialValue == 20,
              onTap: () => valueChanged(20),
            ),
            _SelectTile(
              title: LocaleKeys.disabled_title.tr(),
              selected: initialValue == 0,
              onTap: () => valueChanged(0),
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
