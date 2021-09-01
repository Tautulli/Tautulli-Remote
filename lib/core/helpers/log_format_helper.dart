// @dart=2.9

import 'package:f_logs/f_logs.dart';

class LogFormatHelper {
  static Map<String, dynamic> formatLog(Log log) {
    Map<String, String> timestampMap = createTimestampMap(log.timeInMillis);
    String logLevel = mapLogLevelToString(log.logLevel);

    Map<String, dynamic> logMap = {
      'timestamp': timestampMap,
      'level': logLevel,
      'message': log.text,
    };

    return logMap;
  }

  static Map<String, String> createTimestampMap(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    Map<String, String> timestampMap = {
      'day': dateTime.day.toString().padLeft(2, '0'),
      'month': dateTime.month.toString().padLeft(2, '0'),
      'year': dateTime.year.toString(),
      'hour': dateTime.hour.toString().padLeft(2, '0'),
      'minute': dateTime.minute.toString().padLeft(2, '0'),
      'second': dateTime.second.toString().padLeft(2, '0'),
    };

    return timestampMap;
  }

  static String mapLogLevelToString(LogLevel logLevel) {
    switch (logLevel) {
      case LogLevel.DEBUG:
        return 'DEBUG';
      case LogLevel.INFO:
        return 'INFO';
      case LogLevel.WARNING:
        return 'WARNING';
      case LogLevel.ERROR:
        return 'ERROR';
      default:
        return 'UNKNOWN';
    }
  }
}
