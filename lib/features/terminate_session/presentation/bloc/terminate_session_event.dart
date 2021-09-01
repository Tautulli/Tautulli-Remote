// @dart=2.9

part of 'terminate_session_bloc.dart';

abstract class TerminateSessionEvent extends Equatable {
  const TerminateSessionEvent();
}

/// Takes in a SlidableState to ensure the correct item is removed.
///
/// Without this the delay from awaiting the stream to terminate
/// can allow the user to slide a new widget changing the context.
class TerminateSessionStarted extends TerminateSessionEvent {
  final String tautulliId;
  final String sessionId;
  final String message;
  final SlidableState slidableState;
  final SettingsBloc settingsBloc;

  TerminateSessionStarted({
    this.slidableState,
    @required this.tautulliId,
    @required this.sessionId,
    this.message,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [
        tautulliId,
        sessionId,
        message,
        slidableState,
        settingsBloc,
      ];
}
