import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/datasources/push_data_source.dart';
import '../../domain/usecases/push.dart';

part 'push_status_event.dart';
part 'push_status_state.dart';

class PushStatusBloc extends Bloc<PushStatusEvent, PushStatusState> {
  final Push push;

  PushStatusBloc({
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
          token: await push.token,
          limits: await push.limits,
        ),
      );
    } catch (e) {
      emit(
        PushStatusFailure(),
      );
    }
  }
}
