import '../../domain/entities/notification_log_entry.dart';
import '../../domain/repositories/notification_logs_repository.dart';
import '../datasources/notification_logs_data_source.dart';

class NotificationLogsRepositoryImpl implements NotificationLogsRepository {
  final NotificationLogsDataSource dataSource;

  NotificationLogsRepositoryImpl({required this.dataSource});

  @override
  Future<List<NotificationLogEntry>> getLogs() => dataSource.getLogs();

  @override
  Future<void> clearLogs() => dataSource.clearLogs();
}
