abstract class SettingsRepository {
  // Double Tap To Exit
  Future<bool> getDoubleTapToExit();
  Future<bool> setDoubleTapToExit(bool value);

  // Mask Sensitive Info
  Future<bool> getMaskSensitiveInfo();
  Future<bool> setMaskSensitiveInfo(bool value);

  // OneSignal Consented
  Future<bool> getOneSignalConsented();
  Future<bool> setOneSignalConsented(bool value);

  // Refresh Rate
  Future<int> getRefreshRate();
  Future<bool> setRefreshRate(int value);

  // Server Timeout
  Future<int> getServerTimeout();
  Future<bool> setServerTimeout(int value);
}
