import '../../data/datasources/push_data_source.dart';
import '../repositories/push_repository.dart';

class Push {
  final PushRepository repository;

  Push({required this.repository});

  /// Grants or revokes consent based on the provided boolean.
  Future<void> grantConsent(bool value) => repository.grantConsent(value);

  /// Returns `true` if the user has consented to receiving notifications.
  Future<bool> get hasConsented => repository.hasConsented;

  /// Returns `true` if the OS has granted notification permission.
  Future<bool> get hasNotificationPermission => repository.hasNotificationPermission;

  /// Returns `true` if push notifications are enabled.
  Future<bool> get isOptedIn => repository.isOptedIn;

  /// Returns `true` if the push relay is reachable.
  Future<bool> get isReachable => repository.isReachable;

  /// Returns `true` if this device can currently receive notifications.
  Future<bool> get isSubscribed => repository.isSubscribed;

  /// Returns the relay's current fair-use limit.
  Future<PushLimits> get limits => repository.limits;

  /// Disables or enables push notifications.
  Future<void> optIn(bool value) => repository.optIn(value);

  /// Requests notification permission from the OS.
  Future<bool> requestPermission() => repository.requestPermission();

  /// Returns the push token used to address this device.
  ///
  /// Returns `'push-disabled'` if a token is unavailable.
  Future<String> get token => repository.token;

  /// Returns the push token used to register this device with a Tautulli server.
  ///
  /// Throws `PushTokenUnavailableException` when the token cannot be determined,
  /// so a transient failure is never registered as an opt-out.
  Future<String> get tokenForRegistration => repository.tokenForRegistration;
}
