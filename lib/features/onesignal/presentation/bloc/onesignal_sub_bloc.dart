import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/strings.dart';

import '../../data/datasources/onesignal_data_source.dart';

part 'onesignal_sub_event.dart';
part 'onesignal_sub_state.dart';

String registerErrorTitle = 'Device Has Not Registered With OneSignal';
String registerErrorMessage =
    'This device is attempting to register with OneSignal. This process may take up to 2 min.';
String unexpectedErrorTitle =
    'Unexpected Error With OneSignal Subscription State';
String unexpectedErrorMessage =
    'Please contact Tautulli support for assistance.';

class OneSignalSubBloc extends Bloc<OneSignalSubEvent, OneSignalSubState> {
  final OneSignalDataSource oneSignal;

  OneSignalSubBloc({
    required this.oneSignal,
  }) : super(OneSignalSubInitial()) {
    on<OneSignalSubCheck>(
      (event, emit) => _onOneSignalSubCheck(event, emit),
    );
  }

  void _onOneSignalSubCheck(
    OneSignalSubCheck event,
    Emitter<OneSignalSubState> emit,
  ) async {
    final bool isSubscribed = await oneSignal.isSubscribed;
    final String userId = await oneSignal.userId;

    if (isSubscribed && isNotBlank(userId)) {
      emit(
        OneSignalSubSuccess(),
      );
    } else if (!isSubscribed) {
      emit(
        OneSignalSubFailure(
          title: registerErrorTitle,
          message: registerErrorMessage,
        ),
      );
    } else {
      emit(
        OneSignalSubFailure(
          title: unexpectedErrorTitle,
          message: unexpectedErrorMessage,
        ),
      );
    }
  }
}
