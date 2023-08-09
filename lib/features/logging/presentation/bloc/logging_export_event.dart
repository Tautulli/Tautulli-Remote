part of 'logging_export_bloc.dart';

abstract class LoggingExportEvent extends Equatable {
  const LoggingExportEvent();

  @override
  List<Object> get props => [];
}

class LoggingExportStart extends LoggingExportEvent {
  final BuildContext context;
  final LoggingBloc loggingBloc;

  const LoggingExportStart({
    required this.context,
    required this.loggingBloc,
  });

  @override
  List<Object> get props => [context, loggingBloc];
}
