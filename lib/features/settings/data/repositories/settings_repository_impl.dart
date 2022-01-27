import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;

  SettingsRepositoryImpl({required this.dataSource});

  // Double Tap To Exit
  @override
  Future<bool> getDoubleTapToExit() async {
    return await dataSource.getDoubleTapToExit();
  }

  @override
  Future<bool> setDoubleTapToExit(bool value) async {
    return await dataSource.setDoubleTapToExit(value);
  }

  // Mask Sensitive Info
  @override
  Future<bool> getMaskSensitiveInfo() async {
    return await dataSource.getMaskSensitiveInfo();
  }

  @override
  Future<bool> setMaskSensitiveInfo(bool value) async {
    return await dataSource.setMaskSensitiveInfo(value);
  }

  // OneSignal Banner Dismissed
  @override
  Future<bool> getOneSignalBannerDismissed() async {
    return await dataSource.getOneSignalBannerDismissed();
  }

  @override
  Future<bool> setOneSignalBannerDismissed(bool value) async {
    return await dataSource.setOneSignalBannerDismissed(value);
  }

  // OneSignal Consented
  @override
  Future<bool> getOneSignalConsented() async {
    return await dataSource.getOneSignalConsented();
  }

  @override
  Future<bool> setOneSignalConsented(bool value) async {
    return await dataSource.setOneSignalConsented(value);
  }

  // Refresh Rate
  @override
  Future<int> getRefreshRate() async {
    return await dataSource.getRefreshRate();
  }

  @override
  Future<bool> setRefreshRate(int value) async {
    return await dataSource.setRefreshRate(value);
  }

  // Server Timeout
  @override
  Future<int> getServerTimeout() async {
    return await dataSource.getServerTimeout();
  }

  @override
  Future<bool> setServerTimeout(int value) async {
    return await dataSource.setServerTimeout(value);
  }
}
