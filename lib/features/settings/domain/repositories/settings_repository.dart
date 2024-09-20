import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/tautulli/models/plex_info_model.dart';
import '../../../../core/api/tautulli/models/register_device_model.dart';
import '../../../../core/api/tautulli/models/tautulli_general_settings_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../../../core/types/theme_enhancement_type.dart';
import '../../../../core/types/theme_type.dart';
import '../../data/models/connection_address_model.dart';
import '../../data/models/custom_header_model.dart';

abstract class SettingsRepository {
  //* API Calls
  Future<Either<Failure, Tuple2<bool, bool>>> deleteImageCache(
    String tautulliId,
  );

  Future<Either<Failure, Tuple2<PlexInfoModel, bool>>> getPlexInfo(
    String tautulliId,
  );

  Future<Either<Failure, Tuple2<TautulliGeneralSettingsModel, bool>>> getTautulliSettings(String tautulliId);

  Future<Either<Failure, Tuple2<RegisterDeviceModel, bool>>> registerDevice({
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

  // Server Timeout
  bool getSecret();
  Future<bool> setSecret(bool value);

  // Server Timeout
  int getServerTimeout();
  Future<bool> setServerTimeout(int value);

  // Statistics Stats Type
  PlayMetricType getStatisticsStatType();
  Future<bool> setStatisticsStatType(PlayMetricType value);

  // Statistics Time Range
  int getStatisticsTimeRange();
  Future<bool> setStatisticsTimeRange(int value);

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

  // Use Atkinson Hyperlegible Font
  bool getUseAtkinsonHyperlegible();
  Future<bool> setUseAtkinsonHyperlegible(bool value);

  // Users Sort
  String getUsersSort();
  Future<bool> setUsersSort(String value);

  // Wizard Complete
  bool getWizardComplete();
  Future<bool> setWizardComplete(bool value);
}
