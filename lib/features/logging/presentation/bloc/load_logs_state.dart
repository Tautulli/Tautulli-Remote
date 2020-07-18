part of 'load_logs_bloc.dart';

abstract class LogsState {
  const LogsState();
}

class LogsInitial extends LogsState {}

class LogsExportInProgress extends LogsState {
  final LogFormatHelper logFormatHelper;
  final List<Log> logs;

  LogsExportInProgress({
    @required this.logFormatHelper,
    @required this.logs,
  });
}

class LogsSuccess extends LogsState {
  final LogFormatHelper logFormatHelper;
  final List<Log> logs;

  LogsSuccess({
    @required this.logFormatHelper,
    @required this.logs,
  });
}

class LogsFailure extends LogsState {}
