part of 'notification_logs_bloc.dart';

abstract class NotificationLogsState extends Equatable {
  const NotificationLogsState();

  @override
  List<Object> get props => [];
}

class NotificationLogsInitial extends NotificationLogsState {}

class NotificationLogsSuccess extends NotificationLogsState {
  final List<NotificationLogEntry> logs;
  final DateTime loadedAt;

  const NotificationLogsSuccess({
    required this.logs,
    required this.loadedAt,
  });

  @override
  List<Object> get props => [logs, loadedAt];
}

class NotificationLogsFailure extends NotificationLogsState {}
