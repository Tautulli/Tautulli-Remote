import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/logging_bloc.dart';
import '../../bloc/logging_export_bloc.dart';
import 'clear_logging_ios_dialog.dart';

class LoggingActionsActionSheet extends StatelessWidget {
  const LoggingActionsActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final LoggingBloc loggingBloc = context.read<LoggingBloc>();

    return CupertinoActionSheet(
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(
          LocaleKeys.cancel_title,
          style: TextStyle(color: ThemeHelper.cupertinoActionSheetActionColor()),
        ).tr(),
      ),
      //TODO: Change translations to capitalize all words
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();

            context.read<LoggingExportBloc>().add(
              LoggingExportStart(
                context: context,
                loggingBloc: context.read<LoggingBloc>(),
              ),
            );
          },
          child: Text(
            LocaleKeys.logs_export_menu_item,
            style: TextStyle(color: ThemeHelper.cupertinoActionSheetActionColor()),
          ).tr(),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();

            showCupertinoDialog(
              context: context,
              builder: (context) => BlocProvider.value(
                value: loggingBloc,
                child: const ClearLoggingIosDialog(),
              ),
            );
          },
          child: Text(
            LocaleKeys.logs_clear_menu_item,
            style: TextStyle(color: ThemeHelper.cupertinoActionSheetActionColor()),
          ).tr(),
        ),
      ],
    );
  }
}
