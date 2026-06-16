abstract class OneSignalRepository {
  Future<void> grantConsent(bool value);
  Future<bool> get hasConsented;
  Future<bool> get hasNotificationPermission;
  Future<bool> get isOptedIn;
  Future<bool> get isReachable;
  Future<bool> get isSubscribed;
  Future<void> optIn(bool value);
  Future<String> get userId;
}
