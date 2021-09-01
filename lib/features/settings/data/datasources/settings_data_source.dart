// @dart=2.9

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../domain/entities/plex_server_info.dart';
import '../../domain/entities/tautulli_settings_general.dart';
import '../../presentation/bloc/settings_bloc.dart';
import '../models/plex_server_info_model.dart';
import '../models/tautulli_settings_general_model.dart';

abstract class SettingsDataSource {
  Future<PlexServerInfo> getPlexServerInfo({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  });

  Future<Map<String, dynamic>> getTautulliSettings({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  });

  Future<int> getServerTimeout();

  Future<bool> setServerTimeout(int value);

  Future<int> getRefreshRate();

  Future<bool> setRefreshRate(int value);

  Future<bool> getDoubleTapToExit();

  Future<bool> setDoubleTapToExit(bool value);

  Future<bool> setMaskSensitiveInfo(bool value);

  Future<bool> getMaskSensitiveInfo();

  Future<String> getLastSelectedServer();

  Future<bool> setLastSelectedServer(String tautulliId);

  Future<String> getStatsType();

  Future<bool> setStatsType(String statsType);

  Future<String> getYAxis();

  Future<bool> setYAxis(String yAxis);

  Future<String> getUsersSort();

  Future<bool> setUsersSort(String usersSort);

  Future<bool> getOneSignalBannerDismissed();

  Future<bool> setOneSignalBannerDismissed(bool value);

  Future<bool> getOneSignalConsented();

  Future<bool> setOneSignalConsented(bool value);

  Future<String> getLastAppVersion();

  Future<bool> setLastAppVersion(String lastAppVersion);

  Future<int> getLastReadAnnouncementId();

  Future<bool> setLastReadAnnouncementId(int value);

  Future<bool> getWizardCompleteStatus();

  Future<bool> setWizardCompleteStatus(bool value);

  Future<List<int>> getCustomCertHashList();

  Future<bool> setCustomCertHashList(List<int> certHashList);

  Future<bool> getIosLocalNetworkPermissionPrompted();

  Future<bool> setIosLocalNetworkPermissionPrompted(bool value);

  Future<bool> getGraphTipsShown();

  Future<bool> setGraphTipsShown(bool value);

  Future<bool> getIosNotificationPermissionDeclined();

  Future<bool> setIosNotificationPermissionDeclined(bool value);
}

const SETTINGS_SERVER_TIMEOUT = 'SETTINGS_SERVER_TIMEOUT';
const SETTINGS_REFRESH_RATE = 'SETTINGS_REFRESH_RATE';
const SETTINGS_DOUBLE_TAP_TO_EXIT = 'SETTINGS_DOUBLE_TAP_TO_EXIT';
const SETTINGS_MASK_SENSITIVE_INFO = 'SETTINGS_MASK_SENSITIVE_INFO';
const LAST_SELECTED_SERVER = 'LAST_SELECTED_SERVER';
const STATS_TYPE = 'STATS_TYPE';
const Y_AXIS = 'Y_AXIS';
const USERS_SORT = 'USERS_SORT';
const ONE_SIGNAL_BANNER_DISMISSED = 'ONE_SIGNAL_BANNER_DISMISSED';
const ONE_SIGNAL_CONSENTED = 'ONE_SIGNAL_CONSENTED';
const LAST_APP_VERSION = 'LAST_APP_VERSION';
const LAST_READ_ANNOUNCEMENT_ID = 'LAST_READ_ANNOUNCEMENT_ID';
const WIZARD_COMPLETE_STATUS = 'WIZARD_COMPLETE_STATUS';
const CUSTOM_CERT_HASH_LIST = 'CUSTOM_CERT_HASH_LIST';
const IOS_LOCAL_NETWORK_PERMISSION_PROMPTED =
    'IOS_LOCAL_NETWORK_PERMISSION_PROMPTED';
const GRAPH_TIPS_SHOWN = 'GRAPH_TIPS_SHOWN';
const IOS_NOTIFICATION_PERMISSION_DECLINED =
    'IOS_NOTIFICATION_PERMISSION_DECLINED';

class SettingsDataSourceImpl implements SettingsDataSource {
  final SharedPreferences sharedPreferences;
  final tautulli_api.GetServerInfo apiGetServerInfo;
  final tautulli_api.GetSettings apiGetSettings;

  SettingsDataSourceImpl({
    @required this.sharedPreferences,
    @required this.apiGetServerInfo,
    @required this.apiGetSettings,
  });

  @override
  Future<PlexServerInfo> getPlexServerInfo({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    final plexServerInfoJson = await apiGetServerInfo(
      tautulliId: tautulliId,
      settingsBloc: settingsBloc,
    );

    PlexServerInfo plexServerInfo =
        PlexServerInfoModel.fromJson(plexServerInfoJson['response']['data']);

    return plexServerInfo;
  }

  @override
  Future<Map<String, dynamic>> getTautulliSettings({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    final tautulliSettingsJson = await apiGetSettings(
      tautulliId: tautulliId,
      settingsBloc: settingsBloc,
    );

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
  Future<bool> getDoubleTapToExit() {
    final value = sharedPreferences.getBool(SETTINGS_DOUBLE_TAP_TO_EXIT);
    return Future.value(value);
  }

  @override
  Future<bool> setDoubleTapToExit(bool value) {
    return sharedPreferences.setBool(SETTINGS_DOUBLE_TAP_TO_EXIT, value);
  }

  @override
  Future<bool> getMaskSensitiveInfo() {
    final value = sharedPreferences.getBool(SETTINGS_MASK_SENSITIVE_INFO);
    return Future.value(value);
  }

  @override
  Future<bool> setMaskSensitiveInfo(bool value) {
    return sharedPreferences.setBool(SETTINGS_MASK_SENSITIVE_INFO, value);
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

  @override
  Future<String> getYAxis() {
    final value = sharedPreferences.getString(Y_AXIS);
    return Future.value(value);
  }

  @override
  Future<bool> setYAxis(String yAxis) {
    return sharedPreferences.setString(Y_AXIS, yAxis);
  }

  @override
  Future<String> getUsersSort() {
    final value = sharedPreferences.getString(USERS_SORT);
    return Future.value(value);
  }

  @override
  Future<bool> setUsersSort(String usersSort) {
    return sharedPreferences.setString(USERS_SORT, usersSort);
  }

  @override
  Future<bool> getOneSignalBannerDismissed() {
    final value = sharedPreferences.getBool(ONE_SIGNAL_BANNER_DISMISSED);
    return Future.value(value);
  }

  @override
  Future<bool> setOneSignalBannerDismissed(bool value) {
    return sharedPreferences.setBool(ONE_SIGNAL_BANNER_DISMISSED, value);
  }

  @override
  Future<bool> getOneSignalConsented() {
    final value = sharedPreferences.getBool(ONE_SIGNAL_CONSENTED);
    return Future.value(value);
  }

  @override
  Future<bool> setOneSignalConsented(bool value) {
    return sharedPreferences.setBool(ONE_SIGNAL_CONSENTED, value);
  }

  @override
  Future<String> getLastAppVersion() {
    final value = sharedPreferences.getString(LAST_APP_VERSION);
    return Future.value(value);
  }

  @override
  Future<bool> setLastAppVersion(String lastAppVersion) {
    return sharedPreferences.setString(LAST_APP_VERSION, lastAppVersion);
  }

  @override
  Future<int> getLastReadAnnouncementId() {
    final value = sharedPreferences.getInt(LAST_READ_ANNOUNCEMENT_ID);
    return Future.value(value);
  }

  @override
  Future<bool> setLastReadAnnouncementId(int value) {
    return sharedPreferences.setInt(LAST_READ_ANNOUNCEMENT_ID, value);
  }

  @override
  Future<bool> getWizardCompleteStatus() {
    final value = sharedPreferences.getBool(WIZARD_COMPLETE_STATUS);
    return Future.value(value);
  }

  @override
  Future<bool> setWizardCompleteStatus(bool value) {
    return sharedPreferences.setBool(WIZARD_COMPLETE_STATUS, value);
  }

  @override
  Future<List<int>> getCustomCertHashList() {
    List<String> stringList = [];
    List<int> intList = [];
    try {
      stringList = sharedPreferences.getStringList(CUSTOM_CERT_HASH_LIST);
      intList = stringList.map((i) => int.parse(i)).toList();
    } catch (_) {}

    return Future.value(intList);
  }

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) {
    final List<String> stringList =
        certHashList.map((i) => i.toString()).toList();

    return sharedPreferences.setStringList(CUSTOM_CERT_HASH_LIST, stringList);
  }

  @override
  Future<bool> getIosLocalNetworkPermissionPrompted() {
    final value = sharedPreferences.getBool(
      IOS_LOCAL_NETWORK_PERMISSION_PROMPTED,
    );
    return Future.value(value);
  }

  @override
  Future<bool> setIosLocalNetworkPermissionPrompted(bool value) {
    return sharedPreferences.setBool(
      IOS_LOCAL_NETWORK_PERMISSION_PROMPTED,
      value,
    );
  }

  @override
  Future<bool> getGraphTipsShown() {
    final value = sharedPreferences.getBool(
      GRAPH_TIPS_SHOWN,
    );
    return Future.value(value);
  }

  @override
  Future<bool> setGraphTipsShown(bool value) {
    return sharedPreferences.setBool(
      GRAPH_TIPS_SHOWN,
      value,
    );
  }

  @override
  Future<bool> getIosNotificationPermissionDeclined() {
    final value =
        sharedPreferences.getBool(IOS_NOTIFICATION_PERMISSION_DECLINED);
    return Future.value(value);
  }

  @override
  Future<bool> setIosNotificationPermissionDeclined(bool value) {
    return sharedPreferences.setBool(
      IOS_NOTIFICATION_PERMISSION_DECLINED,
      value,
    );
  }
}
