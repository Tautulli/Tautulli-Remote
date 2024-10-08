import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:system_theme/system_theme.dart';

import '../../../../core/api/tautulli/models/plex_info_model.dart';
import '../../../../core/api/tautulli/models/register_device_model.dart';
import '../../../../core/api/tautulli/models/tautulli_general_settings_model.dart';
import '../../../../core/api/tautulli/tautulli_api.dart';
import '../../../../core/database/data/datasources/database.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/device_info/device_info.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/local_storage/local_storage.dart';
import '../../../../core/package_information/package_information.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../../../core/types/theme_enhancement_type.dart';
import '../../../../core/types/theme_type.dart';
import '../../../../core/utilities/cast.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../onesignal/data/datasources/onesignal_data_source.dart';
import '../models/connection_address_model.dart';
import '../models/custom_header_model.dart';

abstract class SettingsDataSource {
  //* API Calls
  Future<Tuple2<bool, bool>> deleteImageCache(String tautulliId);

  Future<Tuple2<PlexInfoModel, bool>> getPlexInfo(String tautulliId);

  Future<Tuple2<TautulliGeneralSettingsModel, bool>> getTautulliSettings(
    String tautulliId,
  );

  Future<Tuple2<RegisterDeviceModel, bool>> registerDevice({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    List<CustomHeaderModel>? customHeaders,
    bool trustCert,
  });

  //* Database Interactions
  Future<int> addServer(ServerModel server);

  Future<void> deleteServer(int id);

  Future<List<ServerModel>> getAllServers();

  Future<ServerModel?> getServerByTautulliId(String tautulliId);

  Future<List<ServerModel>?> getAllServersWithoutOnesignalRegistered();

  Future<int> updateConnectionInfo({
    required int id,
    required ConnectionAddressModel connectionAddress,
  });

  Future<int> updateCustomHeaders({
    required String tautulliId,
    required List<CustomHeaderModel> headers,
  });

  Future<int> updatePrimaryActive({
    required String tautulliId,
    required bool primaryActive,
  });

  Future<int> updateServer(ServerModel server);

  Future<void> updateServerSort({
    required int serverId,
    required int oldIndex,
    required int newIndex,
  });

  //* Store & Retrive Values
  // Active Server ID
  String getActiveServerId();
  Future<bool> setActiveServerId(String value);

  // App Update Available
  bool getAppUpdateAvailable();
  Future<bool> setAppUpdateAvailable(bool value);

  // Custom Cert Hash List
  List<int> getCustomCertHashList();
  Future<bool> setCustomCertHashList(List<int> certHashList);

  // Disable Image Backgrounds
  bool getDisableImageBackgrounds();
  Future<bool> setDisableImageBackgrounds(bool value);

  // Double Back To Exit
  bool getDoubleBackToExit();
  Future<bool> setDoubleBackToExit(bool value);

  // Graph Time Range
  int getGraphTimeRange();
  Future<bool> setGraphTimeRange(int value);

  // Graph Tips Shown
  bool getGraphTipsShown();
  Future<bool> setGraphTipsShown(bool value);

  // Graph Y Axis
  PlayMetricType getGraphYAxis();
  Future<bool> setGraphYAxis(PlayMetricType value);

  // History Filter
  Map<String, bool> getHistoryFilter();
  Future<bool> setHistoryFilter(Map<String, bool> map);

  // Home Page
  String getHomePage();
  Future<bool> setHomePage(String value);

  // Last App Version
  String getLastAppVersion();
  Future<bool> setLastAppVersion(String value);

  // Last Read Announcement ID
  int getLastReadAnnouncementId();
  Future<bool> setLastReadAnnouncementId(int value);

  // Libraries Sort
  String getLibrariesSort();
  Future<bool> setLibrariesSort(String value);

  // Library Media Full Refresh
  bool getLibraryMediaFullRefresh();
  Future<bool> setLibraryMediaFullRefresh(bool value);

  // Mask Sensitive Info
  bool getMaskSensitiveInfo();
  Future<bool> setMaskSensitiveInfo(bool value);

  // Multiserver Activity
  bool getMultiserverActivity();
  Future<bool> setMultiserverActivity(bool value);

  // OneSignal Banner Dismissed
  bool getOneSignalBannerDismissed();
  Future<bool> setOneSignalBannerDismissed(bool value);

  // OneSignal Consented
  bool getOneSignalConsented();
  Future<bool> setOneSignalConsented(bool value);

  // Recently Added Filter
  String getRecentlyAddedFilter();
  Future<bool> setRecentlyAddedFilter(String value);

  // Refresh Rate
  int getRefreshRate();
  Future<bool> setRefreshRate(int value);

  // Registration Update Needed
  bool getRegistrationUpdateNeeded();
  Future<bool> setRegistrationUpdateNeeded(bool value);

  // Secret
  bool getSecret();
  Future<bool> setSecret(bool value);

  // Server Timeout
  int getServerTimeout();
  Future<bool> setServerTimeout(int value);

  // Statistics Stats Type
  String getStatisticsStatType();
  Future<bool> setStatisticsStatType(PlayMetricType value);

  // Statistics Time Range
  int getStatisticsTimeRange();
  Future<bool> setStatisticsTimeRange(int value);

  // Use Atkinson Hyperlegible Font
  bool getUseAtkinsonHyperlegible();
  Future<bool> setUseAtkinsonHyperlegible(bool value);

  // Theme
  ThemeType getTheme();
  Future<bool> setTheme(ThemeType themeType);

  // Theme Custom Color
  Color getThemeCustomColor();
  Future<bool> setThemeCustomColor(Color color);

  // Theme Enhancement
  ThemeEnhancementType getThemeEnhancement();
  Future<bool> setThemeEnhancement(ThemeEnhancementType themeEnhancementType);

  // Theme Use System Color
  bool getThemeUseSystemColor();
  Future<bool> setThemeUseSystemColor(bool value);

  // Users Sort
  String getUsersSort();
  Future<bool> setUsersSort(String value);

  // Wizard Complete
  bool getWizardComplete();
  Future<bool> setWizardComplete(bool value);
}

const activeServerId = 'activeServerId';
const appUpdateAvailable = 'appUpdateAvailable';
const customCertHashList = 'customCertHashList';
const disableImageBackgrounds = 'disableImageBackgrounds';
const doubleBackToExit = 'doubleTapToExit';
const graphTimeRange = 'graphTimeRange';
const graphTipsShown = 'graphTipsShown';
const graphYAxis = 'graphYAxis';
const historyFilter = 'historyFilter';
const homePage = 'homePage';
const lastAppVersion = 'lastAppVersion';
const lastReadAnnouncementId = 'lastReadAnnouncementId';
const libraryMediaFullRefresh = 'libraryMediaFullRefresh';
const librariesSort = 'librariesSort';
const maskSensitiveInfo = 'maskSensitiveInfo';
const multiserverActivity = 'multiserverActivity';
const oneSignalBannerDismissed = 'oneSignalBannerDismissed';
const oneSignalConsented = 'oneSignalConsented';
const recentlyAddedFilter = 'recentlyAddedFilter';
const refreshRate = 'refreshRate';
const registrationUpdateNeeded = 'registrationUpdateNeeded';
const secret = 'secret';
const serverTimeout = 'serverTimeout';
const statisticsStatType = 'statisticsStatsType';
const statisticsTimeRange = 'statisticsTimeRange';
const theme = 'theme';
const themeCustomColor = 'themeCustomColor';
const themeEnhancement = 'themeEnhancement';
const themeUseSystemColor = 'themeUseSystemColor';
const useAtkinsonHyperlegible = 'userAtkinsonHyperlegible';
const usersSort = 'usersSort';
const wizardComplete = 'wizardComplete';

class SettingsDataSourceImpl implements SettingsDataSource {
  final DeviceInfo deviceInfo;
  final LocalStorage localStorage;
  final PackageInformation packageInfo;
  final DeleteImageCache deleteImageCacheApi;
  final GetServerInfo getServerInfoApi;
  final GetSettings getSettingsApi;
  final RegisterDevice registerDeviceApi;

  SettingsDataSourceImpl({
    required this.deviceInfo,
    required this.localStorage,
    required this.packageInfo,
    required this.deleteImageCacheApi,
    required this.getServerInfoApi,
    required this.getSettingsApi,
    required this.registerDeviceApi,
  });

  //* API Calls
  @override
  Future<Tuple2<bool, bool>> deleteImageCache(String tautulliId) async {
    final result = await deleteImageCacheApi(tautulliId: tautulliId);

    final success = result.value1['response']['result'] == 'success';

    return Tuple2(success, result.value2);
  }

  @override
  Future<Tuple2<PlexInfoModel, bool>> getPlexInfo(String tautulliId) async {
    final result = await getServerInfoApi(tautulliId: tautulliId);

    final plexInfoModel = PlexInfoModel.fromJson(
      result.value1['response']['data'],
    );

    return Tuple2(plexInfoModel, result.value2);
  }

  @override
  Future<Tuple2<TautulliGeneralSettingsModel, bool>> getTautulliSettings(
    String tautulliId,
  ) async {
    final result = await getSettingsApi(tautulliId: tautulliId);

    final generalSettings = TautulliGeneralSettingsModel.fromJson(
      result.value1['response']['data']['General'],
    );

    return Tuple2(generalSettings, result.value2);
  }

  @override
  Future<Tuple2<RegisterDeviceModel, bool>> registerDevice({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    List<CustomHeaderModel>? customHeaders,
    bool trustCert = false,
  }) async {
    final String deviceId = await deviceInfo.uniqueId ?? 'unknown';
    final String deviceName = await deviceInfo.model ?? 'unknown';
    final String oneSignalId = await di.sl<OneSignalDataSource>().userId;
    final String platform = deviceInfo.platform;
    final String version = await packageInfo.version;

    final result = await registerDeviceApi(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
      deviceId: deviceId,
      deviceName: deviceName,
      onesignalId: oneSignalId,
      platform: platform,
      version: version,
      customHeaders: customHeaders,
      trustCert: trustCert,
    );

    final Map<String, dynamic> responseData = result.value1['response']['data'];

    // If response data is missing tautulli_version throw ServerVersionException.
    if (!responseData.containsKey('tautulli_version')) {
      throw ServerVersionException();
    }

    return Tuple2(
      RegisterDeviceModel.fromJson(responseData),
      result.value2,
    );
  }

  //* Database Interactions
  @override
  Future<int> addServer(ServerModel server) async {
    return await DBProvider.db.addServer(server);
  }

  @override
  Future<void> deleteServer(int id) async {
    return await DBProvider.db.deleteServer(id);
  }

  @override
  Future<List<ServerModel>> getAllServers() async {
    return await DBProvider.db.getAllServers();
  }

  @override
  Future<ServerModel?> getServerByTautulliId(String tautulliId) async {
    return await DBProvider.db.getServerByTautulliId(tautulliId);
  }

  @override
  Future<List<ServerModel>?> getAllServersWithoutOnesignalRegistered() async {
    return await DBProvider.db.getAllServersWithoutOnesignalRegistered();
  }

  @override
  Future<int> updateConnectionInfo({
    required int id,
    required ConnectionAddressModel connectionAddress,
  }) async {
    return await DBProvider.db.updateConnectionInfo(
      id: id,
      connectionAddress: connectionAddress,
    );
  }

  @override
  Future<int> updateCustomHeaders({
    required String tautulliId,
    required List<CustomHeaderModel> headers,
  }) async {
    return await DBProvider.db.updateCustomHeaders(
      tautulliId: tautulliId,
      headers: headers,
    );
  }

  @override
  Future<int> updatePrimaryActive({
    required String tautulliId,
    required bool primaryActive,
  }) async {
    return await DBProvider.db.updatePrimaryActive(
      tautulliId: tautulliId,
      primaryActive: primaryActive,
    );
  }

  @override
  Future<int> updateServer(ServerModel server) async {
    return await DBProvider.db.updateServer(server);
  }

  @override
  Future<void> updateServerSort({
    required int serverId,
    required int oldIndex,
    required int newIndex,
  }) async {
    return DBProvider.db.updateServerSort(
      serverId: serverId,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
  }

  //* Store & Retrive Values
  // Active Server ID
  @override
  String getActiveServerId() {
    return localStorage.getString(activeServerId) ?? '';
  }

  @override
  Future<bool> setActiveServerId(String value) {
    return localStorage.setString(activeServerId, value);
  }

  // App Update Available
  @override
  bool getAppUpdateAvailable() {
    return localStorage.getBool(appUpdateAvailable) ?? false;
  }

  @override
  Future<bool> setAppUpdateAvailable(bool value) {
    return localStorage.setBool(appUpdateAvailable, value);
  }

  // Custom Cert Hash List
  @override
  List<int> getCustomCertHashList() {
    List<String> stringList;
    List<int> intList = [];

    stringList = localStorage.getStringList(customCertHashList) ?? [];
    intList = stringList.map((i) => int.parse(i)).toList();

    return intList;
  }

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) {
    final List<String> stringList = certHashList.map((i) => i.toString()).toList();

    return localStorage.setStringList(customCertHashList, stringList);
  }

  // Disable Image Backgrounds
  @override
  bool getDisableImageBackgrounds() {
    return localStorage.getBool(disableImageBackgrounds) ?? false;
  }

  @override
  Future<bool> setDisableImageBackgrounds(bool value) {
    return localStorage.setBool(disableImageBackgrounds, value);
  }

  // Double Back To Exit
  @override
  bool getDoubleBackToExit() {
    return localStorage.getBool(doubleBackToExit) ?? false;
  }

  @override
  Future<bool> setDoubleBackToExit(bool value) {
    return localStorage.setBool(doubleBackToExit, value);
  }

  // Graphs Time Range
  @override
  int getGraphTimeRange() {
    return localStorage.getInt(graphTimeRange) ?? 30;
  }

  @override
  Future<bool> setGraphTimeRange(int value) async {
    return localStorage.setInt(graphTimeRange, value);
  }

  // Graph Tips Shown
  @override
  bool getGraphTipsShown() {
    return localStorage.getBool(graphTipsShown) ?? false;
  }

  @override
  Future<bool> setGraphTipsShown(bool value) async {
    return localStorage.setBool(graphTipsShown, value);
  }

  // Graph Y Axis
  @override
  PlayMetricType getGraphYAxis() {
    String timeRangeString = localStorage.getString(graphYAxis) ?? 'plays';

    if (timeRangeString == 'duration') return PlayMetricType.time;

    return PlayMetricType.plays;
  }

  @override
  Future<bool> setGraphYAxis(PlayMetricType value) async {
    return localStorage.setString(graphYAxis, value.apiValue());
  }

  // History Filter
  @override
  Map<String, bool> getHistoryFilter() {
    final String? value = localStorage.getString(historyFilter);

    return value != null ? Map.castFrom(json.decode(value)) : {};
  }

  @override
  Future<bool> setHistoryFilter(Map<String, bool> map) {
    return localStorage.setString(historyFilter, json.encode(map));
  }

  // Home Page
  @override
  String getHomePage() {
    return localStorage.getString(homePage) ?? 'activity';
  }

  @override
  Future<bool> setHomePage(String value) {
    return localStorage.setString(homePage, value);
  }

  // Last App Version
  @override
  String getLastAppVersion() {
    return localStorage.getString(lastAppVersion) ?? '';
  }

  @override
  Future<bool> setLastAppVersion(String value) {
    return localStorage.setString(lastAppVersion, value);
  }

  // Last Read Announcement ID
  @override
  int getLastReadAnnouncementId() {
    return localStorage.getInt(lastReadAnnouncementId) ?? 0;
  }

  @override
  Future<bool> setLastReadAnnouncementId(int value) {
    return localStorage.setInt(lastReadAnnouncementId, value);
  }

  // Libraries Sort
  @override
  String getLibrariesSort() {
    return localStorage.getString(librariesSort) ?? 'section_name|asc';
  }

  @override
  Future<bool> setLibrariesSort(String value) {
    return localStorage.setString(librariesSort, value);
  }

  // Library Media Full Refresh
  @override
  bool getLibraryMediaFullRefresh() {
    return localStorage.getBool(libraryMediaFullRefresh) ?? true;
  }

  @override
  Future<bool> setLibraryMediaFullRefresh(bool value) {
    return localStorage.setBool(libraryMediaFullRefresh, value);
  }

  // Mask Sensitive Info
  @override
  bool getMaskSensitiveInfo() {
    return localStorage.getBool(maskSensitiveInfo) ?? false;
  }

  @override
  Future<bool> setMaskSensitiveInfo(bool value) {
    return localStorage.setBool(maskSensitiveInfo, value);
  }

  // Multiserver Activity
  @override
  bool getMultiserverActivity() {
    return localStorage.getBool(multiserverActivity) ?? false;
  }

  @override
  Future<bool> setMultiserverActivity(bool value) {
    return localStorage.setBool(multiserverActivity, value);
  }

  // OneSignal Banner Dismissed
  @override
  bool getOneSignalBannerDismissed() {
    return localStorage.getBool(oneSignalBannerDismissed) ?? false;
  }

  @override
  Future<bool> setOneSignalBannerDismissed(bool value) {
    return localStorage.setBool(oneSignalBannerDismissed, value);
  }

  // OneSignal Consented
  @override
  bool getOneSignalConsented() {
    return localStorage.getBool(oneSignalConsented) ?? false;
  }

  @override
  Future<bool> setOneSignalConsented(bool value) {
    return localStorage.setBool(oneSignalConsented, value);
  }

  // Recently Added Filter
  @override
  String getRecentlyAddedFilter() {
    return localStorage.getString(recentlyAddedFilter) ?? 'all';
  }

  @override
  Future<bool> setRecentlyAddedFilter(String value) {
    return localStorage.setString(recentlyAddedFilter, value);
  }

  // Refresh Rate
  @override
  int getRefreshRate() {
    return localStorage.getInt(refreshRate) ?? 0;
  }

  @override
  Future<bool> setRefreshRate(int value) {
    return localStorage.setInt(refreshRate, value);
  }

  // Registration Update Needed
  @override
  bool getRegistrationUpdateNeeded() {
    return localStorage.getBool(registrationUpdateNeeded) ?? false;
  }

  @override
  Future<bool> setRegistrationUpdateNeeded(bool value) {
    return localStorage.setBool(registrationUpdateNeeded, value);
  }

  // Secret
  @override
  bool getSecret() {
    return localStorage.getBool(secret) ?? false;
  }

  @override
  Future<bool> setSecret(bool value) {
    return localStorage.setBool(secret, value);
  }

  // Server Timeout
  @override
  int getServerTimeout() {
    return localStorage.getInt(serverTimeout) ?? 15;
  }

  @override
  Future<bool> setServerTimeout(int value) {
    return localStorage.setInt(serverTimeout, value);
  }

  // Statistics Stat Type
  @override
  String getStatisticsStatType() {
    return localStorage.getString(statisticsStatType) ?? 'plays';
  }

  @override
  Future<bool> setStatisticsStatType(PlayMetricType value) {
    return localStorage.setString(statisticsStatType, value.apiValue());
  }

  // Statistics Time Range
  @override
  int getStatisticsTimeRange() {
    return localStorage.getInt(statisticsTimeRange) ?? 30;
  }

  @override
  Future<bool> setStatisticsTimeRange(int value) async {
    return localStorage.setInt(statisticsTimeRange, value);
  }

  // Theme
  @override
  ThemeType getTheme() {
    final storedTheme = localStorage.getString(theme) ?? 'tautulli';

    return Cast.castStringToThemeType(storedTheme);
  }

  @override
  Future<bool> setTheme(ThemeType themeType) {
    return localStorage.setString(theme, themeType.themeName());
  }

  // Theme Custom Color
  @override
  Color getThemeCustomColor() {
    return Color(
      localStorage.getInt(themeCustomColor) ?? 0xffebaf00,
    );
  }

  @override
  Future<bool> setThemeCustomColor(Color color) {
    return localStorage.setInt(themeCustomColor, color.value);
  }

  // Theme Enhancement
  @override
  ThemeEnhancementType getThemeEnhancement() {
    return Cast.castStringToThemeEnhancementType(
      localStorage.getString(themeEnhancement),
    );
  }

  @override
  Future<bool> setThemeEnhancement(ThemeEnhancementType themeEnhancementType) {
    return localStorage.setString(
      themeEnhancement,
      Cast.castThemeEnhancementTypeToString(themeEnhancementType),
    );
  }

  // Theme Use System Color
  @override
  bool getThemeUseSystemColor() {
    if (di.sl<DeviceInfo>().platform == 'ios') return false;

    if (!defaultTargetPlatform.supportsAccentColor) return false;

    return localStorage.getBool(themeUseSystemColor) ?? true;
  }

  @override
  Future<bool> setThemeUseSystemColor(bool value) {
    return localStorage.setBool(themeUseSystemColor, value);
  }

  // Use Atkinson Hyperlegible Font
  @override
  bool getUseAtkinsonHyperlegible() {
    return localStorage.getBool(useAtkinsonHyperlegible) ?? false;
  }

  @override
  Future<bool> setUseAtkinsonHyperlegible(bool value) {
    return localStorage.setBool(useAtkinsonHyperlegible, value);
  }

  // Users Sort
  @override
  String getUsersSort() {
    return localStorage.getString(usersSort) ?? 'friendly_name|asc';
  }

  @override
  Future<bool> setUsersSort(String value) {
    return localStorage.setString(usersSort, value);
  }

  // Wizard Complete
  @override
  bool getWizardComplete() {
    return localStorage.getBool(wizardComplete) ?? false;
  }

  @override
  Future<bool> setWizardComplete(bool value) {
    return localStorage.setBool(wizardComplete, value);
  }
}
