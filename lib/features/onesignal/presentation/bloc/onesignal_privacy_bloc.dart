import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

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
  final Logging logging;

  OneSignalPrivacyBloc({
    @required this.oneSignal,
    @required this.settings,
    @required this.registerDevice,
    @required this.logging,
  }) : super(OneSignalPrivacyInitial());

  @override
  Stream<OneSignalPrivacyState> mapEventToState(
    OneSignalPrivacyEvent event,
  ) async* {
    if (event is OneSignalPrivacyCheckConsent) {
      yield* _mapOneSignalPrivacyCheckConsentToState();
    }
    if (event is OneSignalPrivacyGrantConsent) {
      yield* _mapOneSignalPrivacyGrantConsentToState();
    }
    if (event is OneSignalPrivacyRevokeConsent) {
      yield* _mapOneSignalPrivacyRevokeConsent();
    }
  }

  Stream<OneSignalPrivacyState>
      _mapOneSignalPrivacyCheckConsentToState() async* {
    if (await oneSignal.hasConsented) {
      yield OneSignalPrivacyConsentSuccess();
    } else {
      yield OneSignalPrivacyConsentFailure(
        iosAppTrackingPermissionGranted:
            await Permission.appTrackingTransparency.isGranted ?? false,
        iosNotificationPermissionGranted:
            await Permission.notification.isGranted ?? false,
      );
    }
  }

  Stream<OneSignalPrivacyState>
      _mapOneSignalPrivacyGrantConsentToState() async* {
    await oneSignal.grantConsent(true);
    await oneSignal.disablePush(false);
    await settings.setOneSignalConsented(true);

    logging.info(
      'OneSignal: Privacy consent accepted',
    );
    yield OneSignalPrivacyConsentSuccess();
  }

  Stream<OneSignalPrivacyState> _mapOneSignalPrivacyRevokeConsent() async* {
    await oneSignal.disablePush(true);
    await oneSignal.grantConsent(false);
    await settings.setOneSignalConsented(false);

    logging.info(
      'OneSignal: Privacy consent revoked',
    );
    yield OneSignalPrivacyConsentFailure(
      iosAppTrackingPermissionGranted:
          await Permission.appTrackingTransparency.isGranted,
      iosNotificationPermissionGranted: await Permission.notification.isGranted,
    );
  }
}
