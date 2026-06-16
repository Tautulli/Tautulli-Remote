import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/onesignal.dart';

part 'onesignal_status_event.dart';
part 'onesignal_status_state.dart';

class OneSignalStatusBloc extends Bloc<OneSignalStatusEvent, OneSignalStatusState> {
  final OneSignal oneSignal;

  OneSignalStatusBloc({
    required this.oneSignal,
  }) : super(OneSignalStatusInitial()) {
    on<OneSignalStatusLoad>((event, emit) => _onOneSignalStatusLoad(event, emit));
  }

  void _onOneSignalStatusLoad(
    OneSignalStatusLoad event,
    Emitter<OneSignalStatusState> emit,
  ) async {
    emit(
      OneSignalStatusInProgress(),
    );

    try {
      emit(
        OneSignalStatusSuccess(
          hasNotificationPermission: await oneSignal.hasNotificationPermission,
          isOptedIn: await oneSignal.isOptedIn,
          isSubscribed: await oneSignal.isSubscribed,
          userId: await oneSignal.userId,
        ),
      );
    } catch (e) {
      emit(
        OneSignalStatusFailure(),
      );
    }
  }
}
