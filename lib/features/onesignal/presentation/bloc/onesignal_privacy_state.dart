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
  final bool iosAppTrackingPermissionGranted;
  final bool iosNotificationPermissionGranted;
  final bool iosNotificationPermissionDeclined;

  OneSignalPrivacyConsentFailure({
    this.iosAppTrackingPermissionGranted,
    this.iosNotificationPermissionGranted,
    this.iosNotificationPermissionDeclined,
  });

  @override
  List<Object> get props => [
        iosAppTrackingPermissionGranted,
        iosNotificationPermissionGranted,
        iosNotificationPermissionDeclined,
      ];
}
