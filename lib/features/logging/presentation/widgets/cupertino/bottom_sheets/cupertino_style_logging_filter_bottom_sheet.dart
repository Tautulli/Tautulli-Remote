import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/model/flog/log_level.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/logging_bloc.dart';

class CupertinoStyleLoggingFilterBottomSheet extends StatelessWidget {
  final LogLevel initialValue;

  const CupertinoStyleLoggingFilterBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    void logLevelChanged(LogLevel value) {
      context.read<LoggingBloc>().add(
        LoggingSetLevel(value),
      );
      Navigator.of(context).pop();
    }

    return CupertinoStyleModalPopupScaffold(
      middleText: LocaleKeys.filter_logs_title.tr(),
      leading: const CupertinoStyleBottomSheetCancelButton(),
      child: CupertinoStyleListSection(
        hasLeading: false,
        children: [
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.ALL);
            },
            titleText: LocaleKeys.all_title.tr(),
            trailing: initialValue == LogLevel.ALL ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.DEBUG);
            },
            titleText: LocaleKeys.debug_title.tr(),
            trailing: initialValue == LogLevel.DEBUG ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.INFO);
            },
            titleText: LocaleKeys.info_title.tr(),
            trailing: initialValue == LogLevel.INFO ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.WARNING);
            },
            titleText: LocaleKeys.warning_title.tr(),
            trailing: initialValue == LogLevel.WARNING ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.ERROR);
            },
            titleText: LocaleKeys.error_title.tr(),
            trailing: initialValue == LogLevel.ERROR ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
