import 'package:f_logs/f_logs.dart';

abstract class LoggingRepository {
  dynamic debug(String text);

  dynamic info(String text);

  dynamic warning(String text);

  dynamic error(String text);

  Future<List<Log>> getAllLogs();

  dynamic clearLogs();
}