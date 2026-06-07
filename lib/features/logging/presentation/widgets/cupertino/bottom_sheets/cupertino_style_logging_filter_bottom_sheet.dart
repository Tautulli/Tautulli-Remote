import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/model/flog/log_level.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
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
    void logLevelChanged(LogLevel value) {
      context.read<LoggingBloc>().add(
        LoggingSetLevel(value),
      );
      Navigator.of(context).pop();
    }

    return CupertinoStyleModalPopupScaffold(
      //TODO: Add translation string
      middleText: 'Filter Logs',
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
            titleText: 'Debug',
            trailing: initialValue == LogLevel.DEBUG ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.INFO);
            },
            titleText: 'Info',
            trailing: initialValue == LogLevel.INFO ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.WARNING);
            },
            titleText: 'Warning',
            trailing: initialValue == LogLevel.WARNING ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CupertinoStyleNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.ERROR);
            },
            titleText: 'Error',
            trailing: initialValue == LogLevel.ERROR ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
