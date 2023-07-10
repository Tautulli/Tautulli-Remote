import 'package:dartz/dartz.dart';

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
  Future<String> getActiveServerId();
  Future<bool> setActiveServerId(String value);

  // Custom Cert Hash List
  Future<List<int>> getCustomCertHashList();
  Future<bool> setCustomCertHashList(List<int> certHashList);

  // Double Back To Exit
  Future<bool> getDoubleBackToExit();
  Future<bool> setDoubleBackToExit(bool value);

  // Graph Time Range
  Future<int> getGraphTimeRange();
  Future<bool> setGraphTimeRange(int value);

  // Graph Tips Shown
  Future<bool> getGraphTipsShown();
  Future<bool> setGraphTipsShown(bool value);

  // Graph Y Axis
  Future<PlayMetricType> getGraphYAxis();
  Future<bool> setGraphYAxis(PlayMetricType value);

  // Last App Version
  Future<String> getLastAppVersion();
  Future<bool> setLastAppVersion(String value);

  // Last Read Announcement ID
  Future<int> getLastReadAnnouncementId();
  Future<bool> setLastReadAnnouncementId(int value);

  // Libraries Sort
  Future<String> getLibrariesSort();
  Future<bool> setLibrariesSort(String value);

  // Library Media Full Refresh
  Future<bool> getLibraryMediaFullRefresh();
  Future<bool> setLibraryMediaFullRefresh(bool value);

  // Mask Sensitive Info
  Future<bool> getMaskSensitiveInfo();
  Future<bool> setMaskSensitiveInfo(bool value);

  // Multiserver Activity
  Future<bool> getMultiserverActivity();
  Future<bool> setMultiserverActivity(bool value);

  // OneSignal Banner Dismissed
  Future<bool> getOneSignalBannerDismissed();
  Future<bool> setOneSignalBannerDismissed(bool value);

  // OneSignal Consented
  Future<bool> getOneSignalConsented();
  Future<bool> setOneSignalConsented(bool value);

  // Refresh Rate
  Future<int> getRefreshRate();
  Future<bool> setRefreshRate(int value);

  // Registration Update Needed
  Future<bool> getRegistrationUpdateNeeded();
  Future<bool> setRegistrationUpdateNeeded(bool value);

  // Secret
  Future<bool> getSecret();
  Future<bool> setSecret(bool value);

  // Server Timeout
  Future<int> getServerTimeout();
  Future<bool> setServerTimeout(int value);

  // Statistics Stats Type
  Future<String> getStatisticsStatType();
  Future<bool> setStatisticsStatType(PlayMetricType value);

  // Statistics Time Range
  Future<int> getStatisticsTimeRange();
  Future<bool> setStatisticsTimeRange(int value);

  // Use Atkinson Hyperlegible Font
  bool getUseAtkinsonHyperlegible();
  Future<bool> setUseAtkinsonHyperlegible(bool value);

  // Users Sort
  Future<String> getUsersSort();
  Future<bool> setUsersSort(String value);

  // Wizard Complete
  Future<bool> getWizardComplete();
  Future<bool> setWizardComplete(bool value);
}

const activeServerId = 'activeServerId';
const customCertHashList = 'customCertHashList';
const doubleBackToExit = 'doubleTapToExit';
const graphTimeRange = 'graphTimeRange';
const graphTipsShown = 'graphTipsShown';
const graphYAxis = 'graphYAxis';
const lastAppVersion = 'lastAppVersion';
const lastReadAnnouncementId = 'lastReadAnnouncementId';
const libraryMediaFullRefresh = 'libraryMediaFullRefresh';
const librariesSort = 'librariesSort';
const maskSensitiveInfo = 'maskSensitiveInfo';
const multiserverActivity = 'multiserverActivity';
const oneSignalBannerDismissed = 'oneSignalBannerDismissed';
const oneSignalConsented = 'oneSignalConsented';
const refreshRate = 'refreshRate';
const registrationUpdateNeeded = 'registrationUpdateNeeded';
const secret = 'secret';
const serverTimeout = 'serverTimeout';
const statisticsStatType = 'statisticsStatsType';
const statisticsTimeRange = 'statisticsTimeRange';
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
    final String platform = await deviceInfo.platform;
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
  Future<String> getActiveServerId() {
    return Future.value(localStorage.getString(activeServerId) ?? '');
  }

  @override
  Future<bool> setActiveServerId(String value) {
    return localStorage.setString(activeServerId, value);
  }

  // Custom Cert Hash List
  @override
  Future<List<int>> getCustomCertHashList() {
    List<String> stringList;
    List<int> intList = [];

    stringList = localStorage.getStringList(customCertHashList) ?? [];
    intList = stringList.map((i) => int.parse(i)).toList();

    return Future.value(intList);
  }

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) {
    final List<String> stringList =
        certHashList.map((i) => i.toString()).toList();

    return localStorage.setStringList(customCertHashList, stringList);
  }

  // Double Back To Exit
  @override
  Future<bool> getDoubleBackToExit() async {
    return Future.value(localStorage.getBool(doubleBackToExit) ?? false);
  }

  @override
  Future<bool> setDoubleBackToExit(bool value) {
    return localStorage.setBool(doubleBackToExit, value);
  }

  // Graphs Time Range
  @override
  Future<int> getGraphTimeRange() async {
    return Future.value(localStorage.getInt(graphTimeRange) ?? 30);
  }

  @override
  Future<bool> setGraphTimeRange(int value) async {
    return localStorage.setInt(graphTimeRange, value);
  }

  // Graph Tips Shown
  @override
  Future<bool> getGraphTipsShown() async {
    return Future.value(localStorage.getBool(graphTipsShown) ?? false);
  }

  @override
  Future<bool> setGraphTipsShown(bool value) async {
    return localStorage.setBool(graphTipsShown, value);
  }

  // Graph Y Axis
  @override
  Future<PlayMetricType> getGraphYAxis() async {
    String timeRangeString = localStorage.getString(graphYAxis) ?? 'plays';

    if (timeRangeString == 'duration') return Future.value(PlayMetricType.time);

    return Future.value(PlayMetricType.plays);
  }

  @override
  Future<bool> setGraphYAxis(PlayMetricType value) async {
    return localStorage.setString(graphYAxis, value.apiValue());
  }

  // Last App Version
  @override
  Future<String> getLastAppVersion() async {
    return Future.value(localStorage.getString(lastAppVersion) ?? '');
  }

  @override
  Future<bool> setLastAppVersion(String value) {
    return localStorage.setString(lastAppVersion, value);
  }

  // Last Read Announcement ID
  @override
  Future<int> getLastReadAnnouncementId() async {
    return Future.value(localStorage.getInt(lastReadAnnouncementId) ?? 0);
  }

  @override
  Future<bool> setLastReadAnnouncementId(int value) {
    return localStorage.setInt(lastReadAnnouncementId, value);
  }

  // Libraries Sort
  @override
  Future<String> getLibrariesSort() async {
    return Future.value(
      localStorage.getString(librariesSort) ?? 'section_name|asc',
    );
  }

  @override
  Future<bool> setLibrariesSort(String value) {
    return localStorage.setString(librariesSort, value);
  }

  // Library Media Full Refresh
  @override
  Future<bool> getLibraryMediaFullRefresh() async {
    return Future.value(localStorage.getBool(libraryMediaFullRefresh) ?? true);
  }

  @override
  Future<bool> setLibraryMediaFullRefresh(bool value) {
    return localStorage.setBool(libraryMediaFullRefresh, value);
  }

  // Mask Sensitive Info
  @override
  Future<bool> getMaskSensitiveInfo() async {
    return Future.value(localStorage.getBool(maskSensitiveInfo) ?? false);
  }

  @override
  Future<bool> setMaskSensitiveInfo(bool value) {
    return localStorage.setBool(maskSensitiveInfo, value);
  }

  // Multiserver Activity
  @override
  Future<bool> getMultiserverActivity() async {
    return Future.value(localStorage.getBool(multiserverActivity) ?? false);
  }

  @override
  Future<bool> setMultiserverActivity(bool value) {
    return localStorage.setBool(multiserverActivity, value);
  }

  // OneSignal Banner Dismissed
  @override
  Future<bool> getOneSignalBannerDismissed() async {
    return Future.value(
      localStorage.getBool(oneSignalBannerDismissed) ?? false,
    );
  }

  @override
  Future<bool> setOneSignalBannerDismissed(bool value) {
    return localStorage.setBool(oneSignalBannerDismissed, value);
  }

  // OneSignal Consented
  @override
  Future<bool> getOneSignalConsented() async {
    return Future.value(
      localStorage.getBool(oneSignalConsented) ?? false,
    );
  }

  @override
  Future<bool> setOneSignalConsented(bool value) {
    return localStorage.setBool(oneSignalConsented, value);
  }

  // Refresh Rate
  @override
  Future<int> getRefreshRate() async {
    return Future.value(localStorage.getInt(refreshRate) ?? 0);
  }

  @override
  Future<bool> setRefreshRate(int value) {
    return localStorage.setInt(refreshRate, value);
  }

  // Registration Update Needed
  @override
  Future<bool> getRegistrationUpdateNeeded() async {
    return Future.value(
        localStorage.getBool(registrationUpdateNeeded) ?? false);
  }

  @override
  Future<bool> setRegistrationUpdateNeeded(bool value) {
    return localStorage.setBool(registrationUpdateNeeded, value);
  }

  // Secret
  @override
  Future<bool> getSecret() async {
    return Future.value(localStorage.getBool(secret) ?? false);
  }

  @override
  Future<bool> setSecret(bool value) {
    return localStorage.setBool(secret, value);
  }

  // Server Timeout
  @override
  Future<int> getServerTimeout() async {
    return Future.value(localStorage.getInt(serverTimeout) ?? 15);
  }

  @override
  Future<bool> setServerTimeout(int value) {
    return localStorage.setInt(serverTimeout, value);
  }

  // Statistics Stat Type
  @override
  Future<String> getStatisticsStatType() async {
    return Future.value(
      localStorage.getString(statisticsStatType) ?? 'plays',
    );
  }

  @override
  Future<bool> setStatisticsStatType(PlayMetricType value) {
    return localStorage.setString(statisticsStatType, value.apiValue());
  }

  // Statistics Time Range
  @override
  Future<int> getStatisticsTimeRange() async {
    return Future.value(localStorage.getInt(statisticsTimeRange) ?? 30);
  }

  @override
  Future<bool> setStatisticsTimeRange(int value) async {
    return localStorage.setInt(statisticsTimeRange, value);
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
  Future<String> getUsersSort() async {
    return Future.value(
      localStorage.getString(usersSort) ?? 'friendly_name|asc',
    );
  }

  @override
  Future<bool> setUsersSort(String value) {
    return localStorage.setString(usersSort, value);
  }

  // Wizard Complete
  @override
  Future<bool> getWizardComplete() async {
    return Future.value(localStorage.getBool(wizardComplete) ?? false);
  }

  @override
  Future<bool> setWizardComplete(bool value) {
    return localStorage.setBool(wizardComplete, value);
  }
}
