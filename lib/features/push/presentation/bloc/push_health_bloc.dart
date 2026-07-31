import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../logging/domain/usecases/logging.dart';
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
      (event, emit) => _onPushHeathCheck(event, emit),
    );
  }

  void _onPushHeathCheck(
    PushHealthCheck event,
    Emitter<PushHealthState> emit,
  ) async {
    emit(
      PushHealthInProgress(),
    );

    if (await push.isReachable) {
      logging.info('Notifications :: Relay is reachable');

      emit(
        PushHealthSuccess(),
      );
    } else {
      logging.warning('Notifications :: Health check failed');

      emit(
        PushHealthFailure(),
      );
    }
  }
}
