import 'package:f_logs/model/flog/log.dart';
import 'package:f_logs/model/flog/log_level.dart';

List<Log> filterLogs({
  required LogLevel level,
  required List<Log> logs,
}) {
  List<Log> filteredLogs = [];

  for (Log log in logs) {
    // Always display error, severe, or fatal
    if ([
      LogLevel.ERROR,
      LogLevel.SEVERE,
      LogLevel.FATAL,
    ].contains(log.logLevel)) {
      filteredLogs.add(log);
    }
    // If level is warning then also display warning log level
    else if (level == LogLevel.WARNING && log.logLevel == LogLevel.WARNING) {
      filteredLogs.add(log);
    }
    // If level is info then also display info and warning
    else if (level == LogLevel.INFO &&
        [
          LogLevel.INFO,
          LogLevel.WARNING,
        ].contains(log.logLevel)) {
      filteredLogs.add(log);
    }
    // If level is debug then also display debug, info, and warning
    else if (level == LogLevel.DEBUG &&
        [
          LogLevel.DEBUG,
          LogLevel.INFO,
          LogLevel.WARNING,
        ].contains(log.logLevel)) {
      filteredLogs.add(log);
    } else if (level == LogLevel.ALL) {
      filteredLogs.add(log);
    }
  }

  return filteredLogs;
}
