part of 'terminate_session_bloc.dart';

abstract class TerminateSessionState extends Equatable {
  const TerminateSessionState();
}

class TerminateSessionInitial extends TerminateSessionState {
  @override
  List<Object> get props => [];
}

class TerminateSessionInProgress extends TerminateSessionState {
  final String sessionId;

  TerminateSessionInProgress({
    @required this.sessionId,
  });

  @override
  List<Object> get props => [sessionId];
}

class TerminateSessionSuccess extends TerminateSessionState {
  final SlidableState slidableState;

  TerminateSessionSuccess({this.slidableState});

  @override
  List<Object> get props => [slidableState];
}

class TerminateSessionFailure extends TerminateSessionState {
  final Failure failure;

  TerminateSessionFailure({@required this.failure});
  
  @override
  List<Object> get props => [failure];
}
