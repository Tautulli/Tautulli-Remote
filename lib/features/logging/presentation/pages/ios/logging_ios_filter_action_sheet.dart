import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/logging_bloc.dart';

class LoggingIosFilterActionSheet extends StatelessWidget {
  final LogLevel initialValue;

  const LoggingIosFilterActionSheet({
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

    return CupertinoActionSheet(
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == LogLevel.ALL,
          onPressed: () {
            logLevelChanged(LogLevel.ALL);
          },
          child: const Text(LocaleKeys.all_title).tr(),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == LogLevel.DEBUG,
          onPressed: () {
            logLevelChanged(LogLevel.DEBUG);
          },
          child: const Text('Debug'),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == LogLevel.INFO,
          onPressed: () {
            logLevelChanged(LogLevel.INFO);
          },
          child: const Text('Info'),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == LogLevel.WARNING,
          onPressed: () {
            logLevelChanged(LogLevel.WARNING);
          },
          child: const Text('Warning'),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: initialValue == LogLevel.ERROR,
          onPressed: () {
            logLevelChanged(LogLevel.ERROR);
          },
          child: const Text('Error'),
        ),
      ],
    );
  }
}
