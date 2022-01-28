part of 'logging_bloc.dart';

abstract class LoggingState extends Equatable {
  const LoggingState();

  @override
  List<Object> get props => [];
}

class LoggingInitial extends LoggingState {}

class LoggingSuccess extends LoggingState {
  final List<Log> logs;
  final LogLevel level;
  final DateTime loadedAt;

  const LoggingSuccess({
    required this.logs,
    required this.level,
    required this.loadedAt,
  });

  @override
  List<Object> get props => [loadedAt];
}

class LoggingFailure extends LoggingState {}
