part of 'onesignal_privacy_bloc.dart';

abstract class OneSignalPrivacyState extends Equatable {
  const OneSignalPrivacyState();
}

class OneSignalPrivacyInitial extends OneSignalPrivacyState {
  @override
  List<Object> get props => [];
}

class OneSignalPrivacyConsentSuccess extends OneSignalPrivacyState {
  @override
  List<Object> get props => [];
}

class OneSignalPrivacyConsentFailure extends OneSignalPrivacyState {
  @override
  List<Object> get props => [];
}
