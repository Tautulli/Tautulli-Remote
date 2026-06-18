import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/usecases/onesignal.dart';

part 'onesignal_privacy_event.dart';
part 'onesignal_privacy_state.dart';

class OneSignalPrivacyBloc extends Bloc<OneSignalPrivacyEvent, OneSignalPrivacyState> {
  final Logging logging;
  final OneSignal oneSignal;
  final Settings settings;
  final SettingsBloc settingsBloc;

  OneSignalPrivacyBloc({
    required this.logging,
    required this.oneSignal,
    required this.settings,
    required this.settingsBloc,
  }) : super(OneSignalPrivacyInitial()) {
    on<OneSignalPrivacyCheck>(
      (event, emit) => _onOneSignalPrivacyCheck(event, emit),
    );
    on<OneSignalPrivacyGrant>(
      (event, emit) => _onOneSignalPrivacyGrant(event, emit),
    );
    on<OneSignalPrivacyReGrant>(
      (event, emit) => _onOneSignalPrivacyReGrant(event, emit),
    );
    on<OneSignalPrivacyRevoke>(
      (event, emit) => _onOneSignalPrivacyRevoke(event, emit),
    );
  }

  void _onOneSignalPrivacyCheck(
    OneSignalPrivacyCheck event,
    Emitter<OneSignalPrivacyState> emit,
  ) async {
    if (await oneSignal.hasConsented) {
      emit(
        OneSignalPrivacySuccess(),
      );
    } else {
      emit(
        OneSignalPrivacyFailure(),
      );
    }
  }

  void _onOneSignalPrivacyGrant(
    OneSignalPrivacyGrant event,
    Emitter<OneSignalPrivacyState> emit,
  ) async {
    try {
      await oneSignal.grantConsent(true);
      await oneSignal.optIn(true);
    } catch (e) {
      logging.error('OneSignal :: Failed to grant consent [$e]');
      emit(OneSignalPrivacyFailure());
      return;
    }

    settingsBloc.add(const SettingsUpdateOneSignalConsented(true));

    logging.info('OneSignal :: Data Privacy accepted');

    emit(
      OneSignalPrivacySuccess(),
    );
  }

  void _onOneSignalPrivacyReGrant(
    OneSignalPrivacyReGrant event,
    Emitter<OneSignalPrivacyState> emit,
  ) async {
    try {
      await oneSignal.grantConsent(true);
      await oneSignal.optIn(true);
    } catch (e) {
      logging.error('OneSignal :: Failed to re-grant consent [$e]');
      emit(OneSignalPrivacyFailure());
      return;
    }

    settingsBloc.add(const SettingsUpdateOneSignalConsented(true));

    logging.info('OneSignal :: OneSignal consent mismatch detected, correcting');

    emit(
      OneSignalPrivacySuccess(),
    );
  }

  void _onOneSignalPrivacyRevoke(
    OneSignalPrivacyRevoke event,
    Emitter<OneSignalPrivacyState> emit,
  ) async {
    try {
      await oneSignal.optIn(false);
      await oneSignal.grantConsent(false);
    } catch (e) {
      logging.error('OneSignal :: Failed to revoke consent [$e]');
      emit(OneSignalPrivacySuccess());
      return;
    }

    settingsBloc.add(const SettingsUpdateOneSignalConsented(false));

    logging.info('OneSignal :: Data Privacy revoked');

    emit(
      OneSignalPrivacyFailure(),
    );
  }
}
