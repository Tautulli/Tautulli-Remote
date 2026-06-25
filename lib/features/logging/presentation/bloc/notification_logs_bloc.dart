import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_log_entry.dart';
import '../../domain/usecases/notification_logs.dart';

part 'notification_logs_event.dart';
part 'notification_logs_state.dart';

class NotificationLogsBloc extends Bloc<NotificationLogsEvent, NotificationLogsState> {
  final NotificationLogs notificationLogs;

  NotificationLogsBloc({
    required this.notificationLogs,
  }) : super(NotificationLogsInitial()) {
    on<NotificationLogsClear>((event, emit) => _onClear(event, emit));
    on<NotificationLogsLoad>((event, emit) => _onLoad(event, emit));
  }

  void _onClear(
    NotificationLogsClear event,
    Emitter<NotificationLogsState> emit,
  ) async {
    try {
      await notificationLogs.clearLogs();

      await Future.delayed(const Duration(milliseconds: 50));

      final logs = await notificationLogs.getLogs();

      emit(
        NotificationLogsSuccess(
          logs: logs,
          loadedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      emit(NotificationLogsFailure());
    }
  }

  void _onLoad(
    NotificationLogsLoad event,
    Emitter<NotificationLogsState> emit,
  ) async {
    try {
      final logs = await notificationLogs.getLogs();

      emit(
        NotificationLogsSuccess(
          logs: logs,
          loadedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      emit(NotificationLogsFailure());
    }
  }
}
