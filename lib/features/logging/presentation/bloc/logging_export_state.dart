part of 'logging_export_bloc.dart';

abstract class LoggingExportState extends Equatable {
  const LoggingExportState();

  @override
  List<Object> get props => [];
}

class LoggingExportInitial extends LoggingExportState {}

class LoggingExportInProgress extends LoggingExportState {}

class LoggingExportSuccess extends LoggingExportState {}

class LoggingExportFailure extends LoggingExportState {}
