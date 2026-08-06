import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/push_status.dart';
import '../../domain/usecases/push.dart';

part 'push_privacy_event.dart';
part 'push_privacy_state.dart';

class PushPrivacyBloc extends Bloc<PushPrivacyEvent, PushPrivacyState> {
  final Logging logging;
  final Push push;
  final SettingsBloc settingsBloc;

  PushPrivacyBloc({
    required this.logging,
    required this.push,
    required this.settingsBloc,
  }) : super(PushPrivacyInitial()) {
    on<PushPrivacyCheck>(
      (event, emit) => _onPushPrivacyCheck(event, emit),
    );
    on<PushPrivacyGrant>(
      (event, emit) => _onPushPrivacyGrant(event, emit),
    );
    on<PushPrivacyRevoke>(
      (event, emit) => _onPushPrivacyRevoke(event, emit),
    );
  }

  void _onPushPrivacyCheck(
    PushPrivacyCheck event,
    Emitter<PushPrivacyState> emit,
  ) async {
    if (await push.hasConsented) {
      emit(
        PushPrivacySuccess(),
      );
    } else {
      emit(
        PushPrivacyFailure(),
      );
    }
  }

  void _onPushPrivacyGrant(
    PushPrivacyGrant event,
    Emitter<PushPrivacyState> emit,
  ) async {
    emit(PushPrivacyInProgress());

    try {
      // Consent is persisted first; the token cannot be minted without it.
      await push.grantConsent(true);
      await push.requestPermission();
      await push.optIn(true);
    } catch (e) {
      logging.error('Notifications :: Failed to grant consent [$e]');
      // Consent is all there is to undo: optIn only throws from setAutoInitEnabled,
      // so reaching here means auto init was never switched on.
      await push.grantConsent(false);
      emit(PushPrivacyFailure());
      return;
    }

    settingsBloc.add(const SettingsUpdateNotificationsConsented(true));

    logging.info('Notifications :: Data Privacy accepted');

    final token = await push.token;
    if (token == pushDisabled) {
      logging.warning(
        'Notifications :: Consent granted but no push token was issued, this device cannot receive notifications yet',
      );
    } else {
      logging.info('Notifications :: Connected to the relay as device ${await push.relayDeviceId}');
    }

    emit(
      PushPrivacySuccess(),
    );
  }

  void _onPushPrivacyRevoke(
    PushPrivacyRevoke event,
    Emitter<PushPrivacyState> emit,
  ) async {
    emit(PushPrivacyInProgress());

    try {
      // Clearing consent before dropping the token stops the next launch from
      // quietly minting a replacement and re-registering it.
      await push.grantConsent(false);
      await push.optIn(false);
    } catch (e) {
      logging.error('Notifications :: Failed to revoke consent [$e]');
      // The token outlived the attempt, so put back both things the revoke had
      // already changed. Leaving either one cleared reports a revocation that
      // did not happen while every registered server still holds a live token:
      // consent alone would say declined, auto init alone would say unsubscribed.
      try {
        await push.grantConsent(true);
        await push.optIn(true);
      } catch (restoreError) {
        logging.error('Notifications :: Failed to restore consent after a failed revoke [$restoreError]');
      }
      emit(PushPrivacySuccess());
      return;
    }

    settingsBloc.add(const SettingsUpdateNotificationsConsented(false));

    logging.info('Notifications :: Disconnected from the relay, the push token for this device was deleted');

    logging.info('Notifications :: Data Privacy revoked');

    emit(
      PushPrivacyFailure(),
    );
  }
}
