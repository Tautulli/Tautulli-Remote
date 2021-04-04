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
    if (await oneSignal.isSubscribed != null) {
      yield OneSignalPrivacyConsentSuccess();
    } else {
      yield OneSignalPrivacyConsentFailure();
    }
  }

  Stream<OneSignalPrivacyState>
      _mapOneSignalPrivacyGrantConsentToState() async* {
    await oneSignal.grantConsent(true);
    await oneSignal.setSubscription(true);

    logging.info(
      'OneSignal: Privacy consent accepted',
    );
    yield OneSignalPrivacyConsentSuccess();
  }

  Stream<OneSignalPrivacyState> _mapOneSignalPrivacyRevokeConsent() async* {
    await oneSignal.setSubscription(false);
    await oneSignal.grantConsent(false);

    logging.info(
      'OneSignal: Privacy consent revoked',
    );
    yield OneSignalPrivacyConsentFailure();
  }
}
