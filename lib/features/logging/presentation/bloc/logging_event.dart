part of 'logging_bloc.dart';

abstract class LoggingEvent extends Equatable {
  const LoggingEvent();

  @override
  List<Object> get props => [];
}

class LoggingLoad extends LoggingEvent {}

class LoggingClear extends LoggingEvent {}

class LoggingSetLevel extends LoggingEvent {
  final LogLevel level;

  const LoggingSetLevel(this.level);

  @override
  List<Object> get props => [level];
}
