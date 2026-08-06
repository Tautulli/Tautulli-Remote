import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/push_status.dart';
import '../../domain/usecases/push.dart';

part 'push_status_event.dart';
part 'push_status_state.dart';

class PushStatusBloc extends Bloc<PushStatusEvent, PushStatusState> {
  final Logging logging;
  final Push push;

  PushStatusBloc({
    required this.logging,
    required this.push,
  }) : super(PushStatusInitial()) {
    on<PushStatusLoad>((event, emit) => _onPushStatusLoad(event, emit));
  }

  void _onPushStatusLoad(
    PushStatusLoad event,
    Emitter<PushStatusState> emit,
  ) async {
    emit(
      PushStatusInProgress(),
    );

    try {
      emit(
        PushStatusSuccess(
          hasNotificationPermission: await push.hasNotificationPermission,
          isOptedIn: await push.isOptedIn,
          isSubscribed: await push.isSubscribed,
          relayDeviceId: await push.relayDeviceId,
          limits: await push.limits,
          usage: await push.usage,
        ),
      );
    } catch (e) {
      logging.error('Notifications :: Failed to load push status [$e]');

      emit(
        PushStatusFailure(),
      );
    }
  }
}
