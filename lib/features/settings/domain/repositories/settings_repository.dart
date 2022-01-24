abstract class SettingsRepository {
  // Server Timeout
  Future<int> getServerTimeout();
  Future<bool> setServerTimeout(int value);
}
