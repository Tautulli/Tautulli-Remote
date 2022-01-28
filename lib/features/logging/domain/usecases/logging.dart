import 'dart:io';

import 'package:f_logs/model/flog/log.dart';

import '../repositories/logging_repository.dart';

class Logging {
  final LoggingRepository repository;

  Logging({required this.repository});

  /// Logs `text` to [FLog] plugin with the log level TRACE.
  void trace(String text) {
    repository.trace(text);
  }

  /// Logs `text` to [FLog] plugin with the log level DEBUG.
  void debug(String text) {
    repository.debug(text);
  }

  /// Logs `text` to [FLog] plugin with the log level INFO.
  void info(String text) {
    repository.info(text);
  }

  /// Logs `text` to [FLog] plugin with the log level WARNING.
  void warning(String text) {
    repository.warning(text);
  }

  /// Logs `text` to [FLog] plugin with the log level ERROR.
  void error(String text) {
    repository.error(text);
  }

  /// Logs `text` to [FLog] plugin with the log level SEVERE.
  void severe(String text) {
    repository.severe(text);
  }

  /// Logs `text` to [FLog] plugin with the log level FATAL.
  void fatal(String text) {
    repository.fatal(text);
  }

  /// Returns a list of [Log] from [FLog] plugin.
  ///
  /// Returns an empty list if there are no logs.
  Future<List<Log>> getAllLogs() {
    return repository.getAllLogs();
  }

  /// Calls [FLog] plugin to clear all logs from database.
  Future<void> clearLogs() {
    return repository.clearLogs();
  }

  /// Calls [FLog] plugin to export the logs to storage.
  Future<File> exportLogs() {
    return repository.exportLogs();
  }
}
