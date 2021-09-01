// @dart=2.9

part of 'onesignal_privacy_bloc.dart';

abstract class OneSignalPrivacyEvent extends Equatable {
  const OneSignalPrivacyEvent();

  @override
  List<Object> get props => [];
}

class OneSignalPrivacyCheckConsent extends OneSignalPrivacyEvent {}

class OneSignalPrivacyGrantConsent extends OneSignalPrivacyEvent {}

class OneSignalPrivacyRevokeConsent extends OneSignalPrivacyEvent {}
