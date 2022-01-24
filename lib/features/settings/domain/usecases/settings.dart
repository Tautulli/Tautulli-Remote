import '../repositories/settings_repository.dart';

class Settings {
  final SettingsRepository repository;

  Settings({required this.repository});

  /// Returns if the app should mask sensitive info.
  ///
  /// If no value is stored returns `false`.
  Future<bool> getMaskSensitiveInfo() async {
    return await repository.getMaskSensitiveInfo();
  }

  /// Sets if the app should mask sensitive info.
  Future<bool> setMaskSensitiveInfo(bool value) async {
    return await repository.setMaskSensitiveInfo(value);
  }

  /// Returns if exiting the app should require two sequential back actions.
  ///
  /// If no value is stored returns `false`.
  Future<bool> getDoubleTapToExit() async {
    return await repository.getDoubleTapToExit();
  }

  /// Sets if exiting the app should require two sequential back actions.
  Future<bool> setDoubleTapToExit(bool value) async {
    return await repository.setDoubleTapToExit(value);
  }

  /// Returns the refresh rate used for auto refreshing activity.
  ///
  /// If no value is stored returns `0`.
  Future<int> getRefreshRate() async {
    return await repository.getRefreshRate();
  }

  /// Set the refresh rate used when automatically updating the activity.
  Future<bool> setRefreshRate(int value) async {
    return await repository.setRefreshRate(value);
  }

  /// How long to wait in seconds before timing out the server connection.
  ///
  /// If no value is stored returns `15`.
  Future<int> getServerTimeout() async {
    return await repository.getServerTimeout();
  }

  /// Sets the time to wait in seconds before timing out the server connection.
  Future<bool> setServerTimeout(int value) async {
    return await repository.setServerTimeout(value);
  }
}
