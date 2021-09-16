// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../presentation/bloc/settings_bloc.dart';
import '../entities/plex_server_info.dart';

abstract class SettingsRepository {
  Future addServer({
    @required ServerModel server,
  });

  Future deleteServer(int id);

  Future updateServer(ServerModel server);

  Future updateServerById({
    @required ServerModel server,
  });

  Future updateServerSort({
    @required int serverId,
    @required int oldIndex,
    @required int newIndex,
  });

  Future<List<ServerModel>> getAllServers();

  Future<List<ServerModel>> getAllServersWithoutOnesignalRegistered();

  Future<ServerModel> getServer(int id);

  Future getServerByTautulliId(String tautulliId);

  Future getCustomHeadersByTautulliId(String tautulliId);

  Future updatePrimaryConnection({
    @required int id,
    @required Map<String, String> primaryConnectionInfo,
  });

  Future updateSecondaryConnection({
    @required int id,
    @required Map<String, String> secondaryConnectionInfo,
  });

  Future updatePrimaryActive({
    @required String tautulliId,
    @required bool primaryActive,
  });

  Future updateCustomHeaders({
    @required String tautulliId,
    @required List<CustomHeaderModel> customHeaders,
  });

  Future<Either<Failure, PlexServerInfo>> getPlexServerInfo({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  });

  Future<Either<Failure, Map<String, dynamic>>> getTautulliSettings({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  });

  Future<int> getServerTimeout();

  Future<bool> setServerTimeout(int value);

  Future<int> getRefreshRate();

  Future<bool> setRefreshRate(int value);

  Future<bool> getDoubleTapToExit();

  Future<bool> setDoubleTapToExit(bool value);

  Future<bool> getMaskSensitiveInfo();

  Future<bool> setMaskSensitiveInfo(bool value);

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
