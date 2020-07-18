import 'package:f_logs/model/flog/log.dart';
import 'package:meta/meta.dart';

import '../../domain/repositories/logging_repository.dart';
import '../datasources/logging_data_source.dart';

class LoggingRepositoryImpl implements LoggingRepository {
  final LoggingDataSource dataSource;

  LoggingRepositoryImpl({@required this.dataSource});

  @override
  debug(String text) {
    dataSource.debug(text);
  }

  @override
  info(String text) {
    dataSource.info(text);
  }

  @override
  warning(String text) {
    dataSource.warning(text);
  }

  @override
  error(String text) {
    dataSource.error(text);
  }

  @override
  Future<List<Log>> getAllLogs() {
    return dataSource.getAllLogs();
  }

  @override
  clearLogs() {
    dataSource.clearLogs();
  }

  @override
  exportLogs() {
    dataSource.exportLogs();
  }
}
