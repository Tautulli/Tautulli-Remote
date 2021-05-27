import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../data/datasources/onesignal_data_source.dart';

part 'onesignal_subscription_event.dart';
part 'onesignal_subscription_state.dart';

const String CONSENT_ERROR_TITLE = 'OneSignal Data Privacy Not Accepted';
const String CONSENT_ERROR_MESSAGE =
    'To receive notifications from Tautulli consent to OneSignal data privacy.';
const String REGISTER_ERROR_TITLE = 'Device Has Not Registered With OneSignal';
const String REGISTER_ERROR_MESSAGE =
    'This device is attempting to register with OneSignal. This process may take up to 2 min.';
const String UNEXPECTED_ERROR_TITLE =
    'Unexpected Error Communicating With OneSignal';
const String UNEXPECTED_ERROR_MESSAGE =
    'Please contact Tautulli support for assistance.';

class OneSignalSubscriptionBloc
    extends Bloc<OneSignalSubscriptionEvent, OneSignalSubscriptionState> {
  final OneSignalDataSource oneSignal;

  OneSignalSubscriptionBloc({@required this.oneSignal})
      : super(OneSignalSubscriptionInitial());

  @override
  Stream<OneSignalSubscriptionState> mapEventToState(
    OneSignalSubscriptionEvent event,
  ) async* {
    if (event is OneSignalSubscriptionCheck) {
      final bool hasConsented = await oneSignal.hasConsented;
      final bool isSubscribed = await oneSignal.isSubscribed;
      final String userId = await oneSignal.userId;

      if (hasConsented == true && isSubscribed == true && isNotEmpty(userId)) {
        yield OneSignalSubscriptionSuccess();
      } else if (hasConsented == false) {
        yield OneSignalSubscriptionFailure(
          title: CONSENT_ERROR_TITLE,
          message: CONSENT_ERROR_MESSAGE,
          consented: false,
        );
      } else if (isSubscribed == false || userId == null) {
        yield OneSignalSubscriptionFailure(
          title: REGISTER_ERROR_TITLE,
          message: REGISTER_ERROR_MESSAGE,
          consented: true,
        );
      } else {
        yield OneSignalSubscriptionFailure(
          title: UNEXPECTED_ERROR_TITLE,
          message: UNEXPECTED_ERROR_MESSAGE,
          consented: true,
        );
      }
    }
  }
}
