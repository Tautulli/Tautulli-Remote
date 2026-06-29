import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/model/flog/log_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/logging_bloc.dart';

class MaterialStyleLoggingFilterBottomSheet extends StatelessWidget {
  final LogLevel initialValue;

  const MaterialStyleLoggingFilterBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    void logLevelChanged(LogLevel value) {
      context.read<LoggingBloc>().add(LoggingSetLevel(value));
      Navigator.of(context).pop();
    }

    Widget checkIfSelected(LogLevel value) => initialValue == value
        ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary)
        : const SizedBox.shrink();

    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.filter_logs_title.tr(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterTile(
              title: LocaleKeys.all_title.tr(),
              trailing: checkIfSelected(LogLevel.ALL),
              onTap: () => logLevelChanged(LogLevel.ALL),
            ),
            _FilterTile(
              title: LocaleKeys.debug_title.tr(),
              trailing: checkIfSelected(LogLevel.DEBUG),
              onTap: () => logLevelChanged(LogLevel.DEBUG),
            ),
            _FilterTile(
              title: LocaleKeys.info_title.tr(),
              trailing: checkIfSelected(LogLevel.INFO),
              onTap: () => logLevelChanged(LogLevel.INFO),
            ),
            _FilterTile(
              title: LocaleKeys.warning_title.tr(),
              trailing: checkIfSelected(LogLevel.WARNING),
              onTap: () => logLevelChanged(LogLevel.WARNING),
            ),
            _FilterTile(
              title: LocaleKeys.error_title.tr(),
              trailing: checkIfSelected(LogLevel.ERROR),
              onTap: () => logLevelChanged(LogLevel.ERROR),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  final String title;
  final Widget trailing;
  final VoidCallback onTap;

  const _FilterTile({
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
