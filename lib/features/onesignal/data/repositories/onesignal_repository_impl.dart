import '../../domain/repositories/onesignal_repository.dart';
import '../datasources/onesignal_data_source.dart';

class OneSignalRepositoryImpl implements OneSignalRepository {
  final OneSignalDataSource dataSource;

  OneSignalRepositoryImpl({required this.dataSource});

  @override
  Future<void> grantConsent(bool value) => dataSource.grantConsent(value);

  @override
  Future<bool> get hasConsented => dataSource.hasConsented;

  @override
  Future<bool> get hasNotificationPermission => dataSource.hasNotificationPermission;

  @override
  Future<bool> get isOptedIn => dataSource.isOptedIn;

  @override
  Future<bool> get isReachable => dataSource.isReachable;

  @override
  Future<bool> get isSubscribed => dataSource.isSubscribed;

  @override
  Future<void> optIn(bool value) => dataSource.optIn(value);

  @override
  Future<String> get userId => dataSource.userId;
}
