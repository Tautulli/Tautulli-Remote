import 'dart:io';

import 'package:f_logs/model/flog/log.dart';

import '../../domain/repositories/logging_repository.dart';
import '../datasources/logging_data_source.dart';

class LoggingRepositoryImpl implements LoggingRepository {
  final LoggingDataSource dataSource;

  LoggingRepositoryImpl({required this.dataSource});

  @override
  void trace(String text) {
    dataSource.trace(text);
  }

  @override
  void debug(String text) {
    dataSource.debug(text);
  }

  @override
  void info(String text) {
    dataSource.info(text);
  }

  @override
  void warning(String text) {
    dataSource.warning(text);
  }

  @override
  void error(String text) {
    dataSource.error(text);
  }

  @override
  void severe(String text) {
    dataSource.severe(text);
  }

  @override
  void fatal(String text) {
    dataSource.fatal(text);
  }

  @override
  Future<List<Log>> getAllLogs() {
    return dataSource.getAllLogs();
  }

  @override
  Future<void> clearLogs() {
    return dataSource.clearLogs();
  }

  @override
  Future<File> exportLogs() {
    return dataSource.exportLogs();
  }
}
