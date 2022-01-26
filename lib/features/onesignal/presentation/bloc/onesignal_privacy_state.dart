part of 'onesignal_privacy_bloc.dart';

abstract class OneSignalPrivacyState extends Equatable {
  const OneSignalPrivacyState();

  @override
  List<Object> get props => [];
}

class OneSignalPrivacyInitial extends OneSignalPrivacyState {}

class OneSignalPrivacySuccess extends OneSignalPrivacyState {}

class OneSignalPrivacyFailure extends OneSignalPrivacyState {}
