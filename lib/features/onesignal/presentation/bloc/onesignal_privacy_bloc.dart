import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/register_device.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../data/datasources/onesignal_data_source.dart';

part 'onesignal_privacy_event.dart';
part 'onesignal_privacy_state.dart';

class OneSignalPrivacyBloc
    extends Bloc<OneSignalPrivacyEvent, OneSignalPrivacyState> {
  final OneSignalDataSource oneSignal;
  final Settings settings;
  final RegisterDevice registerDevice;
  // final UpdateDeviceRegistration updateDeviceRegistration;
  final Logging logging;

  OneSignalPrivacyBloc({
    @required this.oneSignal,
    @required this.settings,
    @required this.registerDevice,
    // @required this.updateDeviceRegistration,
    @required this.logging,
  }) : super(OneSignalPrivacyInitial());

  @override
  Stream<OneSignalPrivacyState> mapEventToState(
    OneSignalPrivacyEvent event,
  ) async* {
    if (event is OneSignalPrivacyCheckConsent) {
      //TODO: Change to debug
      logging.info('OneSignal: Checking for privacy consent');
      if (await oneSignal.isSubscribed != null) {
        //TODO: Change to debug
        logging.info('OneSignal: Privacy consent verified');
        yield OneSignalPrivacyConsentSuccess();
      } else {
        //TODO: Change to debug
        logging.info('OneSignal: Privacy consent has not been granted');
        yield OneSignalPrivacyConsentFailure();
      }
    }
    if (event is OneSignalPrivacyGrantConsent) {
      // final settings = await settings.load();

      oneSignal.grantConsent(true);
      oneSignal.setSubscription(true);

      // if (isNotBlank(settings.connectionAddress) && oneSignal.userId != null) {
      //   updateDeviceRegistration();
      // }
      logging.info('OneSignal: Privacy consent accepted');
      yield OneSignalPrivacyConsentSuccess();
    }
    if (event is OneSignalPrivacyRevokeConsent) {
      // final settings = await settings.load();

      oneSignal.setSubscription(false);
      oneSignal.grantConsent(false);

      // if (isNotBlank(settings.connectionAddress)) {
      //   updateDeviceRegistration(clearOnesignalId: true);
      // }
      logging.info('OneSignal: Privacy consent revoked');
      yield OneSignalPrivacyConsentFailure();
    }
  }
}
