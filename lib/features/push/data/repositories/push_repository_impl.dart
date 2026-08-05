import '../../domain/repositories/push_repository.dart';
import '../datasources/push_data_source.dart';

class PushRepositoryImpl implements PushRepository {
  final PushDataSource dataSource;

  PushRepositoryImpl({required this.dataSource});

  @override
  Future<void> grantConsent(bool value) => dataSource.grantConsent(value);

  @override
  Future<bool> get hasConsented => dataSource.hasConsented;

  @override
  Future<bool> get hasNotificationPermission => dataSource.hasNotificationPermission;

  @override
  Future<bool> get isOptedIn => dataSource.isOptedIn;

  @override
  Future<PushHealth> get isReachable => dataSource.isReachable;

  @override
  Future<bool> get isSubscribed => dataSource.isSubscribed;

  @override
  Future<PushLimits> get limits => dataSource.limits;

  @override
  Future<void> optIn(bool value) => dataSource.optIn(value);

  @override
  Future<bool> requestPermission() => dataSource.requestPermission();

  @override
  Future<String> get relayDeviceId => dataSource.relayDeviceId;

  @override
  Future<PushUsage> get usage => dataSource.usage;

  @override
  Future<String> get token => dataSource.token;

  @override
  Future<String> get tokenForRegistration => dataSource.tokenForRegistration;
}
