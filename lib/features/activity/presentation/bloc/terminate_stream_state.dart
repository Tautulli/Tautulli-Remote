part of 'terminate_stream_bloc.dart';

abstract class TerminateStreamState extends Equatable {
  const TerminateStreamState();

  @override
  List<Object> get props => [];
}

class TerminateStreamInitial extends TerminateStreamState {}

class TerminateStreamInProgress extends TerminateStreamState {
  final String? sessionId;
  final int? sessionKey;

  const TerminateStreamInProgress({
    this.sessionId,
    this.sessionKey,
  });
}

class TerminateStreamFailure extends TerminateStreamState {
  final Failure failure;

  const TerminateStreamFailure({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}

class TerminateStreamSuccess extends TerminateStreamState {}
