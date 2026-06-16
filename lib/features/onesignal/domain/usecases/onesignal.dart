import '../repositories/onesignal_repository.dart';

class OneSignal {
  final OneSignalRepository repository;

  OneSignal({required this.repository});

  /// Grants or revokes consent based on the provided boolean.
  Future<void> grantConsent(bool value) => repository.grantConsent(value);

  /// Returns `true` if the user has granted consent to the OneSignal SDK.
  Future<bool> get hasConsented => repository.hasConsented;

  /// Returns `true` if the OneSignal SDK shows the user has granted notification permission.
  Future<bool> get hasNotificationPermission => repository.hasNotificationPermission;

  /// Returns `true` if the OneSignal SDK has push notifications enabled.
  Future<bool> get isOptedIn => repository.isOptedIn;

  /// Returns `true` if `https://onesignal.com` is reachable.
  Future<bool> get isReachable => repository.isReachable;

  /// Returns `true` if the user is subscribed to OneSignal.
  Future<bool> get isSubscribed => repository.isSubscribed;

  /// Disables or enables push notifications.
  Future<void> optIn(bool value) => repository.optIn(value);

  /// Returns the OneSignal User ID (AKA playerID).
  ///
  /// Returns `'onesignal-disabled'` if an error is thrown.
  Future<String> get userId => repository.userId;
}
