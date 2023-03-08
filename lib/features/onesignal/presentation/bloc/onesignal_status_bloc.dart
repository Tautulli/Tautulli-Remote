import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/datasources/onesignal_data_source.dart';

part 'onesignal_status_event.dart';
part 'onesignal_status_state.dart';

class OneSignalStatusBloc extends Bloc<OneSignalStatusEvent, OneSignalStatusState> {
  final OneSignalDataSource oneSignal;

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
      final deviceState = await oneSignal.state();

      if (deviceState != null) {
        emit(
          OneSignalStatusSuccess(
            hasNotificationPermission: await oneSignal.hasNotificationPermission,
            isPushDisabled: await oneSignal.isPushDisabled,
            isSubscribed: await oneSignal.isSubscribed,
            userId: await oneSignal.userId,
          ),
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      emit(
        OneSignalStatusFailure(),
      );
    }
  }
}
