part of 'terminate_stream_bloc.dart';

abstract class TerminateStreamEvent extends Equatable {
  const TerminateStreamEvent();

  @override
  List<Object> get props => [];
}

class TerminateStreamStarted extends TerminateStreamEvent {
  final ServerModel server;
  final String? sessionId;
  final int? sessionKey;
  final String? message;

  const TerminateStreamStarted({
    required this.server,
    required this.sessionId,
    required this.sessionKey,
    this.message,
  });

  @override
  List<Object> get props => [server];
}
