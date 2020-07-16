part of 'onesignal_privacy_bloc.dart';

abstract class OneSignalPrivacyEvent extends Equatable {
  const OneSignalPrivacyEvent();
}

class OneSignalPrivacyCheckConsent extends OneSignalPrivacyEvent {
  @override
  List<Object> get props => [];
}

class OneSignalPrivacyGrantConsent extends OneSignalPrivacyEvent {
  @override
  List<Object> get props => [];
}

class OneSignalPrivacyRevokeConsent extends OneSignalPrivacyEvent {
  @override
  List<Object> get props => [];
}