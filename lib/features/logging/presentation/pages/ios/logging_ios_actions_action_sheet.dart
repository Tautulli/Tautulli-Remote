import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/logging_bloc.dart';
import '../../bloc/logging_export_bloc.dart';
import '../../widgets/ios/clear_logging_ios_dialog.dart';

class LoggingIosActionsActionSheet extends StatelessWidget {
  const LoggingIosActionsActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final LoggingBloc loggingBloc = context.read<LoggingBloc>();

    return CupertinoActionSheet(
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
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
          child: const Text(LocaleKeys.logs_export_menu_item).tr(),
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
          child: const Text(LocaleKeys.logs_clear_menu_item).tr(),
        ),
      ],
    );
  }
}
