import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../domain/usecases/onesignal.dart';

part 'onesignal_health_event.dart';
part 'onesignal_health_state.dart';

class OneSignalHealthBloc
    extends Bloc<OneSignalHealthEvent, OneSignalHealthState> {
  final Logging logging;
  final OneSignal oneSignal;

  OneSignalHealthBloc({
    required this.logging,
    required this.oneSignal,
  }) : super(OneSignalHealthInitial()) {
    on<OneSignalHealthCheck>(
      (event, emit) => _onOneSignalHeathCheck(event, emit),
    );
  }

  void _onOneSignalHeathCheck(
    OneSignalHealthCheck event,
    Emitter<OneSignalHealthState> emit,
  ) async {
    emit(
      OneSignalHealthInProgress(),
    );

    if (await oneSignal.isReachable) {
      emit(
        OneSignalHealthSuccess(),
      );
    } else {
      logging.warning('OneSignal :: Health check failed');

      emit(
        OneSignalHealthFailure(),
      );
    }
  }
}
