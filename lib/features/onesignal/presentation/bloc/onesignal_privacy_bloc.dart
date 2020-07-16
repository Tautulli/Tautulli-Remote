import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/get_settings.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/register_device.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/update_device_registration.dart';

import '../../data/datasources/onesignal_data_source.dart';

part 'onesignal_privacy_event.dart';
part 'onesignal_privacy_state.dart';

class OneSignalPrivacyBloc
    extends Bloc<OneSignalPrivacyEvent, OneSignalPrivacyState> {
  final OneSignalDataSource oneSignal;
  final GetSettings getSettings;
  final RegisterDevice registerDevice;
  // final UpdateDeviceRegistration updateDeviceRegistration;

  OneSignalPrivacyBloc({
    @required this.oneSignal,
    @required this.getSettings,
    @required this.registerDevice,
    // @required this.updateDeviceRegistration,
  }) : super(OneSignalPrivacyInitial());

  @override
  Stream<OneSignalPrivacyState> mapEventToState(
    OneSignalPrivacyEvent event,
  ) async* {
    if (event is OneSignalPrivacyCheckConsent) {
      if (await oneSignal.isSubscribed != null) {
        yield OneSignalPrivacyConsentSuccess();
      } else {
        yield OneSignalPrivacyConsentFailure();
      }
    }
    if (event is OneSignalPrivacyGrantConsent) {
      // final settings = await getSettings.load();

      oneSignal.grantConsent(true);
      oneSignal.setSubscription(true);

      // if (isNotBlank(settings.connectionAddress) && oneSignal.userId != null) {
      //   updateDeviceRegistration();
      // }

      yield OneSignalPrivacyConsentSuccess();
    }
    if (event is OneSignalPrivacyRevokeConsent) {
      // final settings = await getSettings.load();

      oneSignal.setSubscription(false);
      oneSignal.grantConsent(false);

      // if (isNotBlank(settings.connectionAddress)) {
      //   updateDeviceRegistration(clearOnesignalId: true);
      // }

      yield OneSignalPrivacyConsentFailure();
    }
  }
}
