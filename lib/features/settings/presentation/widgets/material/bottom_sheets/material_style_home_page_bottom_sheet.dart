import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class MaterialStyleHomePageBottomSheet extends StatelessWidget {
  final String initialValue;

  const MaterialStyleHomePageBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    void valueChanged(String value) {
      context.read<SettingsBloc>().add(SettingsUpdateHomePage(value));
      Navigator.of(context).pop();
    }

    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.home_page_title.tr(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SelectTile(
              title: LocaleKeys.activity_title.tr(),
              selected: initialValue == 'activity',
              onTap: () => valueChanged('activity'),
            ),
            _SelectTile(
              title: LocaleKeys.history_title.tr(),
              selected: initialValue == 'history',
              onTap: () => valueChanged('history'),
            ),
            _SelectTile(
              title: LocaleKeys.recently_added_title.tr(),
              selected: initialValue == 'recent',
              onTap: () => valueChanged('recent'),
            ),
            _SelectTile(
              title: LocaleKeys.libraries_title.tr(),
              selected: initialValue == 'libraries',
              onTap: () => valueChanged('libraries'),
            ),
            _SelectTile(
              title: LocaleKeys.users_title.tr(),
              selected: initialValue == 'users',
              onTap: () => valueChanged('users'),
            ),
            _SelectTile(
              title: LocaleKeys.statistics_title.tr(),
              selected: initialValue == 'statistics',
              onTap: () => valueChanged('statistics'),
            ),
            _SelectTile(
              title: LocaleKeys.graphs_title.tr(),
              selected: initialValue == 'graphs',
              onTap: () => valueChanged('graphs'),
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
