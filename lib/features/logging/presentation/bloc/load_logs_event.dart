part of 'load_logs_bloc.dart';

abstract class LogsEvent extends Equatable {
  const LogsEvent();
}

class LogsLoad extends LogsEvent {
  @override
  List<Object> get props => [];
}

class LogsClear extends LogsEvent {
  @override
  List<Object> get props => [];
}

class LogsExport extends LogsEvent {
  @override
  List<Object> get props => [];
}