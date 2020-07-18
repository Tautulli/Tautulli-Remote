import 'package:f_logs/f_logs.dart';
import 'package:meta/meta.dart';

import '../repositories/logging_repository.dart';

class Logging {
  final LoggingRepository repository;

  Logging({@required this.repository});

  /// Logs `text` with the log level DEBUG.
  dynamic debug(String text) {
    repository.debug(text);
  }

  /// Logs `text` with the log level INFO.
  dynamic info(String text) {
    repository.info(text);
  }

  /// Logs `text` with the log level WARNING.
  dynamic warning(String text) {
    repository.warning(text);
  }

  /// Logs `text` with the log level ERROR.
  dynamic error(String text) {
    repository.error(text);
  }

  /// Returns a list of [Log] items.
  ///
  /// Returns an empty list if there are no logs.
  Future<List<Log>> getAllLogs() {
    return repository.getAllLogs();
  }

  /// Clears all logs from database.
  dynamic clearLogs() {
    repository.clearLogs();
  }

  /// Exports all logs to storage.
  dynamic exportLogs() {
    repository.exportLogs();
  }
}
