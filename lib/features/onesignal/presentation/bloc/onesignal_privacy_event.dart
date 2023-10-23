part of 'onesignal_privacy_bloc.dart';

abstract class OneSignalPrivacyEvent extends Equatable {
  const OneSignalPrivacyEvent();

  @override
  List<Object> get props => [];
}

class OneSignalPrivacyCheck extends OneSignalPrivacyEvent {}

class OneSignalPrivacyGrant extends OneSignalPrivacyEvent {
  final SettingsBloc settingsBloc;

  const OneSignalPrivacyGrant({
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [settingsBloc];
}

class OneSignalPrivacyReGrant extends OneSignalPrivacyEvent {
  final SettingsBloc settingsBloc;

  const OneSignalPrivacyReGrant({
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [settingsBloc];
}

class OneSignalPrivacyRevoke extends OneSignalPrivacyEvent {
  final SettingsBloc settingsBloc;

  const OneSignalPrivacyRevoke({
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [settingsBloc];
}
