import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/usecases/push.dart';

part 'push_privacy_event.dart';
part 'push_privacy_state.dart';

class PushPrivacyBloc extends Bloc<PushPrivacyEvent, PushPrivacyState> {
  final Logging logging;
  final Push push;
  final Settings settings;
  final SettingsBloc settingsBloc;

  PushPrivacyBloc({
    required this.logging,
    required this.push,
    required this.settings,
    required this.settingsBloc,
  }) : super(PushPrivacyInitial()) {
    on<PushPrivacyCheck>(
      (event, emit) => _onPushPrivacyCheck(event, emit),
    );
    on<PushPrivacyGrant>(
      (event, emit) => _onPushPrivacyGrant(event, emit),
    );
    on<PushPrivacyReGrant>(
      (event, emit) => _onPushPrivacyReGrant(event, emit),
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
    try {
      // Consent is persisted first; the token cannot be minted without it.
      await push.grantConsent(true);
      await push.requestPermission();
      await push.optIn(true);
    } catch (e) {
      logging.error('Notifications :: Failed to grant consent [$e]');
      await push.grantConsent(false);
      emit(PushPrivacyFailure());
      return;
    }

    settingsBloc.add(const SettingsUpdateNotificationsConsented(true));

    logging.info('Notifications :: Data Privacy accepted');

    emit(
      PushPrivacySuccess(),
    );
  }

  void _onPushPrivacyReGrant(
    PushPrivacyReGrant event,
    Emitter<PushPrivacyState> emit,
  ) async {
    try {
      await push.grantConsent(true);
      await push.optIn(true);
    } catch (e) {
      logging.error('Notifications :: Failed to re-grant consent [$e]');
      emit(PushPrivacyFailure());
      return;
    }

    settingsBloc.add(const SettingsUpdateNotificationsConsented(true));

    logging.info('Notifications :: Consent mismatch detected, correcting');

    emit(
      PushPrivacySuccess(),
    );
  }

  void _onPushPrivacyRevoke(
    PushPrivacyRevoke event,
    Emitter<PushPrivacyState> emit,
  ) async {
    try {
      // Clearing consent before dropping the token stops the next launch from
      // quietly minting a replacement and re-registering it.
      await push.grantConsent(false);
      await push.optIn(false);
    } catch (e) {
      logging.error('Notifications :: Failed to revoke consent [$e]');
      emit(PushPrivacySuccess());
      return;
    }

    settingsBloc.add(const SettingsUpdateNotificationsConsented(false));

    logging.info('Notifications :: Data Privacy revoked');

    emit(
      PushPrivacyFailure(),
    );
  }
}
