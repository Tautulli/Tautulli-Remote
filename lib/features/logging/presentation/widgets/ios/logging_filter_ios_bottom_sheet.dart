import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/model/flog/log_level.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/logging_bloc.dart';

class LoggingFilterIosBottomSheet extends StatelessWidget {
  final LogLevel initialValue;

  const LoggingFilterIosBottomSheet({
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

    return PageScaffoldCupertino(
      //TODO: Add translation string
      middle: const Text('Filter Logs'),
      leading: const IosBottomSheetCancelButton(),
      child: CustomCupertinoListSection(
        hasLeading: false,
        children: [
          CustomNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.ALL);
            },
            title: const Text(LocaleKeys.all_title).tr(),
            trailing: initialValue == LogLevel.ALL ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.DEBUG);
            },
            title: const Text('Debug'),
            trailing: initialValue == LogLevel.DEBUG ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.INFO);
            },
            title: const Text('Info'),
            trailing: initialValue == LogLevel.INFO ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.WARNING);
            },
            title: const Text('Warning'),
            trailing: initialValue == LogLevel.WARNING ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
          CustomNotchedCupertinoListTile(
            onTap: () {
              logLevelChanged(LogLevel.ERROR);
            },
            title: const Text('Error'),
            trailing: initialValue == LogLevel.ERROR ? const Icon(CupertinoIcons.checkmark_alt) : null,
          ),
        ],
      ),
    );
  }
}
