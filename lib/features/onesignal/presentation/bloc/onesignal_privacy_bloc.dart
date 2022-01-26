import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onesignal_privacy_event.dart';
part 'onesignal_privacy_state.dart';

class OneSignalPrivacyBloc
    extends Bloc<OneSignalPrivacyEvent, OneSignalPrivacyState> {
  OneSignalPrivacyBloc() : super(OneSignalPrivacyInitial()) {
    on<OneSignalPrivacyEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
