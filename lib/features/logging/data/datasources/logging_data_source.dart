import 'package:f_logs/f_logs.dart';

abstract class LoggingDataSource {
  /// Logs `text` to [FLog] plugin with the log level DEBUG.
  dynamic debug(String text);

  /// Logs `text` to [FLog] plugin with the log level INFO.
  dynamic info(String text);

  /// Logs `text` to [FLog] plugin with the log level WARNING.
  dynamic warning(String text);

  /// Logs `text` to [FLog] plugin with the log level ERROR.
  dynamic error(String text);

  /// Returns a list of [Log] from [FLog] plugin.
  /// 
  /// Returns an empty list if there are no logs.
  Future<List<Log>> getAllLogs();

  /// Calls [FLog] plugin to clear all logs from storage.
  dynamic clearLogs();
}

class LoggingDataSourceImpl implements LoggingDataSource {
  @override
  debug(String text) {
    FLog.debug(text: text);
  }

  @override
  info(String text) {
    FLog.info(text: text);
  }

  @override
  warning(String text) {
    FLog.warning(text: text);
  }

  @override
  error(String text) {
    FLog.error(text: text);
  }

  @override
  Future<List<Log>> getAllLogs() {
    return FLog.getAllLogs();
  }

  @override
  clearLogs() {
    FLog.clearLogs();
  }
}
