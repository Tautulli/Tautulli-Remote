import '../entities/notification_log_entry.dart';
import '../repositories/notification_logs_repository.dart';

class NotificationLogs {
  final NotificationLogsRepository repository;

  NotificationLogs({required this.repository});

  Future<List<NotificationLogEntry>> getLogs() => repository.getLogs();

  Future<void> clearLogs() => repository.clearLogs();
}
