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
    //TODO: Change to debug
    // logging.info('OneSignal: Checking for privacy consent');
    if (await oneSignal.isSubscribed != null) {
      //TODO: Change to debug
      // logging.info('OneSignal: Privacy consent verified');
      yield OneSignalPrivacyConsentSuccess();
    } else {
      //TODO: Change to debug
      // logging.info('OneSignal: Privacy consent has not been granted');
      yield OneSignalPrivacyConsentFailure();
    }
  }

  Stream<OneSignalPrivacyState>
      _mapOneSignalPrivacyGrantConsentToState() async* {
    oneSignal.grantConsent(true);
    oneSignal.setSubscription(true);

    logging.info('OneSignal: Privacy consent accepted');
    yield OneSignalPrivacyConsentSuccess();
  }

  Stream<OneSignalPrivacyState> _mapOneSignalPrivacyRevokeConsent() async* {
    oneSignal.setSubscription(false);
    oneSignal.grantConsent(false);

    logging.info('OneSignal: Privacy consent revoked');
    yield OneSignalPrivacyConsentFailure();
  }
}
