// @dart=2.9

import 'package:f_logs/f_logs.dart';

abstract class LoggingRepository {
  /// Logs `text` with the log level DEBUG.
  dynamic debug(String text);

  /// Logs `text` with the log level INFO.
  dynamic info(String text);

  /// Logs `text` with the log level WARNING.
  dynamic warning(String text);

  /// Logs `text` with the log level DEBUG.
  dynamic error(String text);

  /// Returns a list of [Log] items.
  /// 
  /// Returns an empty list if there are no logs.
  Future<List<Log>> getAllLogs();

  /// Clears all logs from database.
  dynamic clearLogs();

  /// Exports logs to storage;
  dynamic exportLogs();
}
