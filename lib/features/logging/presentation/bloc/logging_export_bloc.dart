import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/usecases/logging.dart';
import 'logging_bloc.dart';

part 'logging_export_event.dart';
part 'logging_export_state.dart';

class LoggingExportBloc extends Bloc<LoggingExportEvent, LoggingExportState> {
  final Logging logging;

  LoggingExportBloc({
    required this.logging,
  }) : super(LoggingExportInitial()) {
    on<LoggingExportStart>((event, emit) => _onLoggingExportStart(event, emit));
  }

  void _onLoggingExportStart(
    LoggingExportStart event,
    Emitter<LoggingExportState> emit,
  ) async {
    emit(
      LoggingExportInProgress(),
    );

    try {
      logging.info('Logging :: Exporting logs started');

      await logging.exportLogs().then(
        (file) async {
          return await SharePlus.instance
              .share(
                ShareParams(
                  files: [XFile(file.path)],
                  subject: 'Tautulli Remote Logs',
                  sharePositionOrigin: event.sharePositionOrigin,
                ),
              )
              .then((shareResult) {
                switch (shareResult.status) {
                  case ShareResultStatus.success:
                    logging.info('Logging :: Exporting logs successful');
                    return;
                  case ShareResultStatus.dismissed:
                    logging.info('Logging :: Exporting logs cancelled');
                    return;
                  case ShareResultStatus.unavailable:
                    logging.info('Logging :: Exporting logs failed');
                }
              });
        },
      );

      // Allow time to record above logging before loading new logging
      await Future.delayed(const Duration(milliseconds: 50));

      event.loggingBloc.add(LoggingLoad());

      emit(
        LoggingExportSuccess(),
      );
    } catch (_) {
      emit(
        LoggingExportFailure(),
      );
    }
  }
}
