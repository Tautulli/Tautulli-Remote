import 'dart:io';

import 'package:f_logs/model/flog/log.dart';

abstract class LoggingRepository {
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
