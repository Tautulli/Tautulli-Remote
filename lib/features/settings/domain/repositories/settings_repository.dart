import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/models/plex_info_model.dart';
import '../../../../core/api/tautulli/models/register_device_model.dart';
import '../../../../core/api/tautulli/models/tautulli_general_settings_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/types/play_metric_type.dart';
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

  Future<Either<Failure, Tuple2<TautulliGeneralSettingsModel, bool>>>
      getTautulliSettings(String tautulliId);

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

  // Server Timeout
  Future<bool> getSecret();
  Future<bool> setSecret(bool value);

  // Server Timeout
  Future<int> getServerTimeout();
  Future<bool> setServerTimeout(int value);

  // Statistics Stats Type
  Future<PlayMetricType> getStatisticsStatType();
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
