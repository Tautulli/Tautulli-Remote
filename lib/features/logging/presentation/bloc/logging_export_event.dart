part of 'logging_export_bloc.dart';

abstract class LoggingExportEvent extends Equatable {
  const LoggingExportEvent();

  @override
  List<Object> get props => [];
}

class LoggingExportStart extends LoggingExportEvent {
  final Rect? sharePositionOrigin;
  final LoggingBloc loggingBloc;

  const LoggingExportStart({
    this.sharePositionOrigin,
    required this.loggingBloc,
  });

  @override
  List<Object> get props => [loggingBloc];
}
