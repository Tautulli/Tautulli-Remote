import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_logs/f_logs.dart';
import 'package:meta/meta.dart';

import '../../../../core/helpers/log_format_helper.dart';
import '../../domain/usecases/logging.dart';

part 'load_logs_event.dart';
part 'load_logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  final LogFormatHelper logFormatHelper;
  final Logging logging;

  LogsBloc({
    @required this.logFormatHelper,
    @required this.logging,
  }) : super(LogsInitial());

  @override
  Stream<LogsState> mapEventToState(
    LogsEvent event,
  ) async* {
    if (event is LogsLoad) {
      yield* _mapLogsLoadToState();
    }
    if (event is LogsClear) {
      yield* _mapLogsClearToState();
    }
    if (event is LogsExport) {
      yield* _mapLogsExportToState();
    }
  }

  Stream<LogsState> _mapLogsLoadToState() async* {
    List<Log> logs = await _fetchLogs();

    yield LogsSuccess(
      logFormatHelper: logFormatHelper,
      logs: logs,
    );
  }

  Stream<LogsState> _mapLogsClearToState() async* {
    logging.clearLogs();
    yield LogsSuccess(
      logFormatHelper: logFormatHelper,
      logs: [],
    );
  }

  Stream<LogsState> _mapLogsExportToState() async* {
    List<Log> logs = await _fetchLogs();

    yield LogsExportInProgress(
      logFormatHelper: logFormatHelper,
      logs: logs,
    );

    logging.exportLogs();

    //? Use a completer or similar to force this to wait for the above logging?
    logs = await _fetchLogs();

    yield LogsSuccess(
      logFormatHelper: logFormatHelper,
      logs: logs,
    );
  }

  Future<List<Log>> _fetchLogs() async {
    final List<Log> logs = await logging.getAllLogs();
    final List<Log> reversedLogs = List.from(logs.reversed);
    return reversedLogs;
  }
}
