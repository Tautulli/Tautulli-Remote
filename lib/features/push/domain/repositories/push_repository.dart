import '../../data/datasources/push_data_source.dart';

abstract class PushRepository {
  Future<void> grantConsent(bool value);
  Future<bool> get hasConsented;
  Future<bool> get hasNotificationPermission;
  Future<bool> get isOptedIn;
  Future<bool> get isReachable;
  Future<bool> get isSubscribed;
  Future<PushLimits> get limits;
  Future<void> optIn(bool value);
  Future<bool> requestPermission();
  Future<PushUsage> get usage;

  Future<String> get token;

  Future<String> get tokenForRegistration;
}
