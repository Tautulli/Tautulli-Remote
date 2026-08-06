import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../data/datasources/push_data_source.dart';
import '../../domain/usecases/push.dart';

part 'push_health_event.dart';
part 'push_health_state.dart';

class PushHealthBloc extends Bloc<PushHealthEvent, PushHealthState> {
  final Logging logging;
  final Push push;

  PushHealthBloc({
    required this.logging,
    required this.push,
  }) : super(PushHealthInitial()) {
    on<PushHealthCheck>(
      (event, emit) => _onPushHealthCheck(event, emit),
    );
  }

  void _onPushHealthCheck(
    PushHealthCheck event,
    Emitter<PushHealthState> emit,
  ) async {
    emit(
      PushHealthInProgress(),
    );

    final health = await push.isReachable;

    if (health == PushHealth.reachable) {
      // Runs on settings entry, on data dump entry, on every consent toggle and
      // on a token refresh, so a successful probe is a detail rather than
      // something an operator wants in a normal log.
      logging.debug('Notifications :: Relay is reachable');

      emit(
        PushHealthSuccess(),
      );
    } else {
      if (health == PushHealth.offline) {
        logging.info('Notifications :: Skipped the relay health check, this device is offline');
      } else {
        logging.warning('Notifications :: Unable to reach the relay');
      }

      emit(
        PushHealthFailure(),
      );
    }
  }
}
