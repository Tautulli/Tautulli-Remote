part of 'onesignal_privacy_bloc.dart';

abstract class OneSignalPrivacyEvent extends Equatable {
  const OneSignalPrivacyEvent();

  @override
  List<Object> get props => [];
}

class OneSignalPrivacyCheck extends OneSignalPrivacyEvent {}

class OneSignalPrivacyGrant extends OneSignalPrivacyEvent {}

class OneSignalPrivacyRevoke extends OneSignalPrivacyEvent {}
