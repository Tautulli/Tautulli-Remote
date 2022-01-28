import 'dart:io';

import 'package:f_logs/f_logs.dart';

abstract class LoggingDataSource {
  void trace(String text);

  void debug(String text);

  void info(String text);

  void warning(String text);

  void error(String text);

  void severe(String text);

  void fatal(String text);

  Future<List<Log>> getAllLogs();

  Future<void> clearLogs();

  Future<File> exportLogs();
}

class LoggingDataSourceImpl implements LoggingDataSource {
  @override
  void trace(String text) {
    FLog.trace(text: text);
  }

  @override
  void debug(String text) {
    FLog.debug(text: text);
  }

  @override
  void info(String text) {
    FLog.info(text: text);
  }

  @override
  void warning(String text) {
    FLog.warning(text: text);
  }

  @override
  void error(String text) {
    FLog.error(text: text);
  }

  @override
  void severe(String text) {
    FLog.severe(text: text);
  }

  @override
  void fatal(String text) {
    FLog.fatal(text: text);
  }

  @override
  Future<List<Log>> getAllLogs() {
    return FLog.getAllLogs();
  }

  @override
  Future<void> clearLogs() {
    return FLog.clearLogs();
  }

  @override
  Future<File> exportLogs() {
    return FLog.exportLogs();
  }
}
