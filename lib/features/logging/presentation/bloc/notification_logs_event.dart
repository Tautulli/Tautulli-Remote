part of 'notification_logs_bloc.dart';

abstract class NotificationLogsEvent extends Equatable {
  const NotificationLogsEvent();

  @override
  List<Object> get props => [];
}

class NotificationLogsLoad extends NotificationLogsEvent {}

class NotificationLogsClear extends NotificationLogsEvent {}
