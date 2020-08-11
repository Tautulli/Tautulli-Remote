import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsDataSource {
  Future<int> getServerTimeout();

  Future<bool> setServerTimeout(int value);

  Future<int> getRefreshRate();

  Future<bool> setRefreshRate(int value);

  Future<String> getLastSelectedServer();

  Future<bool> setLastSelectedServer(String tautulliId);
}

const SETTINGS_SERVER_TIMEOUT = 'SETTINGS_SERVER_TIMEOUT';
const SETTINGS_REFRESH_RATE = 'SETTINGS_REFRESH_RATE';
const LAST_SELECTED_SERVER = 'LAST_SELECTED_SERVER';

class SettingsDataSourceImpl implements SettingsDataSource {
  final SharedPreferences sharedPreferences;

  SettingsDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<int> getServerTimeout() {
    final value = sharedPreferences.getInt(SETTINGS_SERVER_TIMEOUT);
    return Future.value(value);
  }

  @override
  Future<bool> setServerTimeout(int value) {
    return sharedPreferences.setInt(SETTINGS_SERVER_TIMEOUT, value);
  }

  @override
  Future<int> getRefreshRate() {
    final value = sharedPreferences.getInt(SETTINGS_REFRESH_RATE);
    return Future.value(value);
  }

  @override
  Future<bool> setRefreshRate(int value) {
    return sharedPreferences.setInt(SETTINGS_REFRESH_RATE, value);
  }

  @override
  Future<String> getLastSelectedServer() {
    final value = sharedPreferences.getString(LAST_SELECTED_SERVER);
    return Future.value(value);
  }

  @override
  Future<bool> setLastSelectedServer(String tautulliId) {
    return sharedPreferences.setString(LAST_SELECTED_SERVER, tautulliId);
  }
}
