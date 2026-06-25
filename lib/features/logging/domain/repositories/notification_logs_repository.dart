import '../entities/notification_log_entry.dart';

abstract class NotificationLogsRepository {
  Future<List<NotificationLogEntry>> getLogs();
  Future<void> clearLogs();
}
