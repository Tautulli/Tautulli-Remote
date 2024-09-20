import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/tautulli/models/plex_info_model.dart';
import '../../../../core/api/tautulli/models/register_device_model.dart';
import '../../../../core/api/tautulli/models/tautulli_general_settings_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../../../core/types/theme_enhancement_type.dart';
import '../../../../core/types/theme_type.dart';
import '../../../../core/utilities/cast.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_data_source.dart';
import '../models/connection_address_model.dart';
import '../models/custom_header_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;
  final NetworkInfo networkInfo;

  SettingsRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  //* API Calls
  @override
  Future<Either<Failure, Tuple2<bool, bool>>> deleteImageCache(
    String tautulliId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.deleteImageCache(tautulliId);

        return Right(result);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Tuple2<PlexInfoModel, bool>>> getPlexInfo(
    String tautulliId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlexInfo(tautulliId);

        return Right(result);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Tuple2<TautulliGeneralSettingsModel, bool>>> getTautulliSettings(String tautulliId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getTautulliSettings(tautulliId);

        return Right(result);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Tuple2<RegisterDeviceModel, bool>>> registerDevice({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    List<CustomHeaderModel>? customHeaders,
    bool trustCert = false,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.registerDevice(
          connectionProtocol: connectionProtocol,
          connectionDomain: connectionDomain,
          connectionPath: connectionPath,
          deviceToken: deviceToken,
          customHeaders: customHeaders,
          trustCert: trustCert,
        );

        return Right(result);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  //* Database Interactions
  @override
  Future<int> addServer(ServerModel server) async {
    return await dataSource.addServer(server);
  }

  @override
  Future<void> deleteServer(int id) async {
    return await dataSource.deleteServer(id);
  }

  @override
  Future<List<ServerModel>> getAllServers() async {
    return await dataSource.getAllServers();
  }

  @override
  Future<ServerModel?> getServerByTautulliId(String tautulliId) async {
    return await dataSource.getServerByTautulliId(tautulliId);
  }

  @override
  Future<List<ServerModel>?> getAllServersWithoutOnesignalRegistered() async {
    return await dataSource.getAllServersWithoutOnesignalRegistered();
  }

  @override
  Future<int> updateConnectionInfo({
    required int id,
    required ConnectionAddressModel connectionAddress,
  }) async {
    return await dataSource.updateConnectionInfo(
      id: id,
      connectionAddress: connectionAddress,
    );
  }

  @override
  Future<int> updateCustomHeaders({
    required String tautulliId,
    required List<CustomHeaderModel> headers,
  }) async {
    return await dataSource.updateCustomHeaders(
      tautulliId: tautulliId,
      headers: headers,
    );
  }

  @override
  Future<int> updatePrimaryActive({
    required String tautulliId,
    required bool primaryActive,
  }) async {
    return await dataSource.updatePrimaryActive(
      tautulliId: tautulliId,
      primaryActive: primaryActive,
    );
  }

  @override
  Future<int> updateServer(ServerModel server) async {
    return await dataSource.updateServer(server);
  }

  @override
  Future<void> updateServerSort({
    required int serverId,
    required int oldIndex,
    required int newIndex,
  }) async {
    return await dataSource.updateServerSort(
      serverId: serverId,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
  }

  //* Store & Retrive Values
  // Active Server ID
  @override
  String getActiveServerId() {
    return dataSource.getActiveServerId();
  }

  @override
  Future<bool> setActiveServerId(String value) async {
    return await dataSource.setActiveServerId(value);
  }

  // App Update Available
  @override
  bool getAppUpdateAvailable() {
    return dataSource.getAppUpdateAvailable();
  }

  @override
  Future<bool> setAppUpdateAvailable(bool value) async {
    return await dataSource.setAppUpdateAvailable(value);
  }

  // Custom Cert Hash List
  @override
  List<int> getCustomCertHashList() {
    return dataSource.getCustomCertHashList();
  }

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return await dataSource.setCustomCertHashList(certHashList);
  }

  // Disable Image Backgrounds
  @override
  bool getDisableImageBackgrounds() {
    return dataSource.getDisableImageBackgrounds();
  }

  @override
  Future<bool> setDisableImageBackgrounds(bool value) {
    return dataSource.setDisableImageBackgrounds(value);
  }

  // Double Back To Exit
  @override
  bool getDoubleBackToExit() {
    return dataSource.getDoubleBackToExit();
  }

  @override
  Future<bool> setDoubleBackToExit(bool value) async {
    return await dataSource.setDoubleBackToExit(value);
  }

  // Graphs Time Range
  @override
  int getGraphTimeRange() {
    return dataSource.getGraphTimeRange();
  }

  @override
  Future<bool> setGraphTimeRange(int value) async {
    return await dataSource.setGraphTimeRange(value);
  }

  // Graph Tips Shown
  @override
  bool getGraphTipsShown() {
    return dataSource.getGraphTipsShown();
  }

  @override
  Future<bool> setGraphTipsShown(bool value) async {
    return await dataSource.setGraphTipsShown(value);
  }

  // Graph Y Axis
  @override
  PlayMetricType getGraphYAxis() {
    return dataSource.getGraphYAxis();
  }

  @override
  Future<bool> setGraphYAxis(PlayMetricType value) async {
    return await dataSource.setGraphYAxis(value);
  }

  // History Filter
  @override
  Map<String, bool> getHistoryFilter() {
    return dataSource.getHistoryFilter();
  }

  @override
  Future<bool> setHistoryFilter(Map<String, bool> map) async {
    return await dataSource.setHistoryFilter(map);
  }

  // Home Page
  @override
  String getHomePage() {
    return dataSource.getHomePage();
  }

  @override
  Future<bool> setHomePage(String value) async {
    return await dataSource.setHomePage(value);
  }

  // Last App Version
  @override
  String getLastAppVersion() {
    return dataSource.getLastAppVersion();
  }

  @override
  Future<bool> setLastAppVersion(String value) async {
    return await dataSource.setLastAppVersion(value);
  }

  // Last Read Announcement ID
  @override
  int getLastReadAnnouncementId() {
    return dataSource.getLastReadAnnouncementId();
  }

  @override
  Future<bool> setLastReadAnnouncementId(int value) async {
    return await dataSource.setLastReadAnnouncementId(value);
  }

  // Libraries Sort
  @override
  String getLibrariesSort() {
    return dataSource.getLibrariesSort();
  }

  @override
  Future<bool> setLibrariesSort(String value) async {
    return await dataSource.setLibrariesSort(value);
  }

  // Library Media Full Refresh
  @override
  bool getLibraryMediaFullRefresh() {
    return dataSource.getLibraryMediaFullRefresh();
  }

  @override
  Future<bool> setLibraryMediaFullRefresh(bool value) async {
    return await dataSource.setLibraryMediaFullRefresh(value);
  }

  // Mask Sensitive Info
  @override
  bool getMaskSensitiveInfo() {
    return dataSource.getMaskSensitiveInfo();
  }

  @override
  Future<bool> setMaskSensitiveInfo(bool value) async {
    return await dataSource.setMaskSensitiveInfo(value);
  }

  // Multiserver Activity
  @override
  bool getMultiserverActivity() {
    return dataSource.getMultiserverActivity();
  }

  @override
  Future<bool> setMultiserverActivity(bool value) async {
    return await dataSource.setMultiserverActivity(value);
  }

  // OneSignal Banner Dismissed
  @override
  bool getOneSignalBannerDismissed() {
    return dataSource.getOneSignalBannerDismissed();
  }

  @override
  Future<bool> setOneSignalBannerDismissed(bool value) async {
    return await dataSource.setOneSignalBannerDismissed(value);
  }

  // OneSignal Consented
  @override
  bool getOneSignalConsented() {
    return dataSource.getOneSignalConsented();
  }

  @override
  Future<bool> setOneSignalConsented(bool value) async {
    return await dataSource.setOneSignalConsented(value);
  }

  // Recently Added Filter
  @override
  String getRecentlyAddedFilter() {
    return dataSource.getRecentlyAddedFilter();
  }

  @override
  Future<bool> setRecentlyAddedFilter(String value) async {
    return await dataSource.setRecentlyAddedFilter(value);
  }

  // Refresh Rate
  @override
  int getRefreshRate() {
    return dataSource.getRefreshRate();
  }

  @override
  Future<bool> setRefreshRate(int value) async {
    return await dataSource.setRefreshRate(value);
  }

  // Refresh Rate
  @override
  bool getRegistrationUpdateNeeded() {
    return dataSource.getRegistrationUpdateNeeded();
  }

  @override
  Future<bool> setRegistrationUpdateNeeded(bool value) async {
    return await dataSource.setRegistrationUpdateNeeded(value);
  }

  // Secret
  @override
  bool getSecret() {
    return dataSource.getSecret();
  }

  @override
  Future<bool> setSecret(bool value) async {
    return await dataSource.setSecret(value);
  }

  // Server Timeout
  @override
  int getServerTimeout() {
    return dataSource.getServerTimeout();
  }

  @override
  Future<bool> setServerTimeout(int value) async {
    return await dataSource.setServerTimeout(value);
  }

  // Statistics Stat Type
  @override
  PlayMetricType getStatisticsStatType() {
    return Cast.castStringToPlayMetricType(
          dataSource.getStatisticsStatType(),
        ) ??
        PlayMetricType.unknown;
  }

  @override
  Future<bool> setStatisticsStatType(PlayMetricType value) async {
    return await dataSource.setStatisticsStatType(value);
  }

  // Statistics Time Range
  @override
  int getStatisticsTimeRange() {
    return dataSource.getStatisticsTimeRange();
  }

  @override
  Future<bool> setStatisticsTimeRange(int value) async {
    return await dataSource.setStatisticsTimeRange(value);
  }

  // Theme
  @override
  ThemeType getTheme() {
    return dataSource.getTheme();
  }

  @override
  Future<bool> setTheme(ThemeType themeType) {
    return dataSource.setTheme(themeType);
  }

  // Theme Custom Color
  @override
  Color getThemeCustomColor() {
    return dataSource.getThemeCustomColor();
  }

  @override
  Future<bool> setThemeCustomColor(Color color) {
    return dataSource.setThemeCustomColor(color);
  }

  // Theme Enhancement
  @override
  ThemeEnhancementType getThemeEnhancement() {
    return dataSource.getThemeEnhancement();
  }

  @override
  Future<bool> setThemeEnhancement(ThemeEnhancementType themeEnhancementType) {
    return dataSource.setThemeEnhancement(themeEnhancementType);
  }

  // Theme Use System Color
  @override
  bool getThemeUseSystemColor() {
    return dataSource.getThemeUseSystemColor();
  }

  @override
  Future<bool> setThemeUseSystemColor(bool value) {
    return dataSource.setThemeUseSystemColor(value);
  }

  // Use Atkinson Hyperlegible Font
  @override
  bool getUseAtkinsonHyperlegible() {
    return dataSource.getUseAtkinsonHyperlegible();
  }

  @override
  Future<bool> setUseAtkinsonHyperlegible(bool value) async {
    return await dataSource.setUseAtkinsonHyperlegible(value);
  }

  // Users Sort
  @override
  String getUsersSort() {
    return dataSource.getUsersSort();
  }

  @override
  Future<bool> setUsersSort(String value) async {
    return await dataSource.setUsersSort(value);
  }

  // Wizard Complete
  @override
  bool getWizardComplete() {
    return dataSource.getWizardComplete();
  }

  @override
  Future<bool> setWizardComplete(bool value) async {
    return await dataSource.setWizardComplete(value);
  }
}
