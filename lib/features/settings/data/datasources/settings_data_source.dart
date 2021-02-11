import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
import '../../domain/entities/plex_server_info.dart';
import '../../domain/entities/tautulli_settings_general.dart';
import '../models/plex_server_info_model.dart';
import '../models/tautulli_settings_general_model.dart';

abstract class SettingsDataSource {
  Future<PlexServerInfo> getPlexServerInfo(String tautulliId);

  Future<Map<String, dynamic>> getTautulliSettings(String tautulliId);

  Future<int> getServerTimeout();

  Future<bool> setServerTimeout(int value);

  Future<int> getRefreshRate();

  Future<bool> setRefreshRate(int value);

  Future<String> getLastSelectedServer();

  Future<bool> setLastSelectedServer(String tautulliId);

  Future<String> getStatsType();

  Future<bool> setStatsType(String statsType);
}

const SETTINGS_SERVER_TIMEOUT = 'SETTINGS_SERVER_TIMEOUT';
const SETTINGS_REFRESH_RATE = 'SETTINGS_REFRESH_RATE';
const LAST_SELECTED_SERVER = 'LAST_SELECTED_SERVER';
const STATS_TYPE = 'STATS_TYPE';

class SettingsDataSourceImpl implements SettingsDataSource {
  final SharedPreferences sharedPreferences;
  final tautulliApi.GetServerInfo apiGetServerInfo;
  final tautulliApi.GetSettings apiGetSettings;

  SettingsDataSourceImpl({
    @required this.sharedPreferences,
    @required this.apiGetServerInfo,
    @required this.apiGetSettings,
  });

  @override
  Future<PlexServerInfo> getPlexServerInfo(String tautulliId) async {
    final plexServerInfoJson = await apiGetServerInfo(tautulliId);

    PlexServerInfo plexServerInfo =
        PlexServerInfoModel.fromJson(plexServerInfoJson['response']['data']);

    return plexServerInfo;
  }

  @override
  Future<Map<String, dynamic>> getTautulliSettings(String tautulliId) async {
    final tautulliSettingsJson = await apiGetSettings(tautulliId);

    TautulliSettingsGeneral tautulliSettingsGeneral =
        TautulliSettingsGeneralModel.fromJson(
            tautulliSettingsJson['response']['data']['General']);

    return {
      'general': tautulliSettingsGeneral,
    };
  }

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

  @override
  Future<String> getStatsType() {
    final value = sharedPreferences.getString(STATS_TYPE);
    return Future.value(value);
  }

  @override
  Future<bool> setStatsType(String statsType) {
    return sharedPreferences.setString(STATS_TYPE, statsType);
  }
}
