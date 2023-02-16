part of 'terminate_stream_bloc.dart';

abstract class TerminateStreamEvent extends Equatable {
  const TerminateStreamEvent();

  @override
  List<Object> get props => [];
}

class TerminateStreamStarted extends TerminateStreamEvent {
  final String tautulliId;
  final String? sessionId;
  final int? sessionKey;
  final String? message;
  final SettingsBloc settingsBloc;

  const TerminateStreamStarted({
    required this.tautulliId,
    required this.sessionId,
    required this.sessionKey,
    this.message,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, settingsBloc];
}
