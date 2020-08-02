import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/terminate_session.dart';

part 'terminate_session_event.dart';
part 'terminate_session_state.dart';

class TerminateSessionBloc
    extends Bloc<TerminateSessionEvent, TerminateSessionState> {
  final TerminateSession terminateSession;

  TerminateSessionBloc({
    @required this.terminateSession,
  }) : super(TerminateSessionInitial());

  @override
  Stream<TerminateSessionState> mapEventToState(
    TerminateSessionEvent event,
  ) async* {
    if (event is TerminateSessionStarted) {
      yield TerminateSessionInProgress(
        sessionId: event.sessionId,
      );

      final terminateStreamOrFailure = await terminateSession(
        tautulliId: event.tautulliId,
        sessionId: event.sessionId,
        message: event.message,
      );

      yield* terminateStreamOrFailure.fold(
        (failure) async* {
          yield TerminateSessionFailure(
            failure: failure,
          );
        },
        (success) async* {
          yield TerminateSessionSuccess(
            slidableState: event.slidableState,
          );
        },
      );
    }
  }
}
