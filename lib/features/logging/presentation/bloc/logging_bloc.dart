import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_logs/model/flog/log.dart';
import 'package:f_logs/model/flog/log_level.dart';

import '../../domain/usecases/logging.dart';

part 'logging_event.dart';
part 'logging_state.dart';

List<Log> logCache = [];
LogLevel levelCache = LogLevel.ALL;

class LoggingBloc extends Bloc<LoggingEvent, LoggingState> {
  final Logging logging;

  LoggingBloc({
    required this.logging,
  }) : super(LoggingInitial()) {
    on<LoggingClear>((event, emit) => _onLoggingClear(event, emit));
    on<LoggingLoad>((event, emit) => _onLoggingLoad(event, emit));
    on<LoggingSetLevel>((event, emit) => _onLoggingSetLevel(event, emit));
  }

  void _onLoggingClear(
    LoggingClear event,
    Emitter<LoggingState> emit,
  ) async {
    try {
      logging.clearLogs();

      logging.info('Logging :: Cleared Logs');

      // Allow time to record above logging before loading new logging
      await Future.delayed(const Duration(milliseconds: 50));

      final logs = await logging.getAllLogs();
      final reversedLogs = logs.reversed.toList();
      logCache = reversedLogs;

      emit(
        LoggingSuccess(
          logs: reversedLogs,
          level: levelCache,
          loadedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      emit(
        LoggingFailure(),
      );
    }
  }

  void _onLoggingLoad(
    LoggingLoad event,
    Emitter<LoggingState> emit,
  ) async {
    try {
      final logs = await logging.getAllLogs();
      final reversedLogs = logs.reversed.toList();
      logCache = reversedLogs;

      emit(
        LoggingSuccess(
          logs: reversedLogs,
          level: levelCache,
          loadedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      emit(
        LoggingFailure(),
      );
    }
  }

  void _onLoggingSetLevel(
    LoggingSetLevel event,
    Emitter<LoggingState> emit,
  ) async {
    levelCache = event.level;

    emit(
      LoggingSuccess(
        logs: logCache,
        level: event.level,
        loadedAt: DateTime.now(),
      ),
    );
  }
}
