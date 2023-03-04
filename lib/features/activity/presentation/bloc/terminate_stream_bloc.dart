import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/usecases/activity.dart';

part 'terminate_stream_event.dart';
part 'terminate_stream_state.dart';

class TerminateStreamBloc extends Bloc<TerminateStreamEvent, TerminateStreamState> {
  final Activity activity;
  final Logging logging;

  TerminateStreamBloc({
    required this.activity,
    required this.logging,
  }) : super(TerminateStreamInitial()) {
    on<TerminateStreamStarted>(_onTerminateStreamStarted);
  }

  Future<void> _onTerminateStreamStarted(
    TerminateStreamStarted event,
    Emitter<TerminateStreamState> emit,
  ) async {
    emit(
      TerminateStreamInProgress(
        sessionId: event.sessionId,
        sessionKey: event.sessionKey,
      ),
    );

    if (event.sessionId == null && event.sessionKey == null) {
      final failure = GenericFailure();

      logging.error('Activity :: Failed to terminate session, no session key or ID found [$failure]');

      return emit(
        TerminateStreamFailure(
          failure: failure,
        ),
      );
    }

    final failureOrTerminateStream = await activity.terminateStream(
      tautulliId: event.server.tautulliId,
      sessionId: event.sessionId,
      sessionKey: event.sessionKey,
      message: event.message,
    );

    await failureOrTerminateStream.fold(
      (failure) async {
        logging.error('Activity :: Failed to terminate session ${event.sessionId} [$failure]');

        emit(
          TerminateStreamFailure(
            failure: failure,
          ),
        );
      },
      (terminateStream) async {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: terminateStream.value2,
          ),
        );

        emit(
          TerminateStreamSuccess(),
        );
      },
    );
  }
}
