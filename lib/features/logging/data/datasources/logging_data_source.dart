import 'package:f_logs/f_logs.dart';

abstract class LoggingDataSource {
  dynamic debug(String text);

  dynamic info(String text);

  dynamic warning(String text);

  dynamic error(String text);

  Future<List<Log>> getAllLogs();
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
}
