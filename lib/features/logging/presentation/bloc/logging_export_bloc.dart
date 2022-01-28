import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
      logging.exportLogs();

      logging.info('Logging :: Exported logs');

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
