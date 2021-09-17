// @dart=2.9

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/data/datasources/database.dart';
import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/plex_server_info.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../presentation/bloc/settings_bloc.dart';
import '../datasources/settings_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;
  final NetworkInfo networkInfo;

  SettingsRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future addServer({
    @required ServerModel server,
  }) async {
    return await DBProvider.db.addServer(server);
  }

  @override
  Future deleteServer(int id) async {
    return await DBProvider.db.deleteServer(id);
  }

  @override
  Future updateServer(ServerModel server) async {
    return await DBProvider.db.updateServer(server);
  }

  @override
  Future updateServerById({
    @required ServerModel server,
  }) async {
    return await DBProvider.db.updateServerById(server);
  }

  @override
  Future updateServerSort({
    @required int serverId,
    @required int oldIndex,
    @required int newIndex,
  }) async {
    return await DBProvider.db.updateServerSort(
      serverId,
      oldIndex,
      newIndex,
    );
  }

  @override
  Future<List<ServerModel>> getAllServers() async {
    List<ServerModel> settingsList = await DBProvider.db.getAllServers();

    return settingsList;
  }

  @override
  Future<List<ServerModel>> getAllServersWithoutOnesignalRegistered() async {
    List<ServerModel> settingsList =
        await DBProvider.db.getAllServersWithoutOnesignalRegistered();

    return settingsList;
  }

  @override
  Future<ServerModel> getServer(int id) async {
    final settings = await DBProvider.db.getServer(id);

    return settings;
  }

  @override
  Future getServerByTautulliId(String tautulliId) async {
    return await DBProvider.db.getServerByTautulliId(tautulliId);
  }

  @override
  Future getCustomHeadersByTautulliId(String tautulliId) async {
    final String encodedHeaders =
        await DBProvider.db.getCustomHeadersByTautulliId(tautulliId) ?? '{}';
    final Map<String, dynamic> decodedHeaders = json.decode(encodedHeaders);

    final List<CustomHeaderModel> customHeaderList = [];

    decodedHeaders.forEach((key, value) {
      customHeaderList.add(
        CustomHeaderModel(
          key: key,
          value: value,
        ),
      );
    });

    return customHeaderList;
  }

  @override
  Future updatePrimaryConnection({
    @required int id,
    @required Map<String, String> primaryConnectionInfo,
  }) async {
    return await DBProvider.db.updateConnection(
      id: id,
      dbConnectionAddressMap: primaryConnectionInfo,
    );
  }

  @override
  Future updateSecondaryConnection({
    @required int id,
    @required Map<String, String> secondaryConnectionInfo,
  }) async {
    return await DBProvider.db.updateConnection(
      id: id,
      dbConnectionAddressMap: secondaryConnectionInfo,
    );
  }

  @override
  Future updatePrimaryActive({
    @required String tautulliId,
    @required bool primaryActive,
  }) async {
    int value;

    switch (primaryActive) {
      case (false):
        value = 0;
        break;
      case (true):
        value = 1;
        break;
    }

    return await DBProvider.db.updatePrimaryActive(
      tautulliId: tautulliId,
      primaryActive: value,
    );
  }

  @override
  Future updateCustomHeaders({
    @required String tautulliId,
    @required List<CustomHeaderModel> customHeaders,
  }) async {
    Map<String, String> customHeaderMap = {};
    customHeaders.forEach((customHeader) {
      customHeaderMap['${customHeader.key}'] = '${customHeader.value}';
    });

    return await DBProvider.db.updateCustomHeaders(
      tautulliId: tautulliId,
      encodedCustomHeaders: json.encode(customHeaderMap),
    );
  }

  @override
  Future<Either<Failure, PlexServerInfo>> getPlexServerInfo({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final plexServerInfo = await dataSource.getPlexServerInfo(
          tautulliId: tautulliId,
          settingsBloc: settingsBloc,
        );
        return Right(plexServerInfo);
      } catch (exception) {
        final Failure failure =
            FailureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTautulliSettings({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final tautulliSettingsMap = await dataSource.getTautulliSettings(
          tautulliId: tautulliId,
          settingsBloc: settingsBloc,
        );
        return Right(tautulliSettingsMap);
      } catch (exception) {
        final Failure failure =
            FailureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<int> getServerTimeout() async {
    final serverTimeout = await dataSource.getServerTimeout();
    return serverTimeout;
  }

  @override
  Future<bool> setServerTimeout(int value) async {
    return dataSource.setServerTimeout(value);
  }

  @override
  Future<int> getRefreshRate() async {
    final refreshRate = await dataSource.getRefreshRate();
    return refreshRate;
  }

  @override
  Future<bool> setRefreshRate(int value) async {
    return dataSource.setRefreshRate(value);
  }

  @override
  Future<bool> getDoubleTapToExit() async {
    final doubleTapToExit = await dataSource.getDoubleTapToExit();
    return doubleTapToExit;
  }

  @override
  Future<bool> setDoubleTapToExit(bool value) async {
    return dataSource.setDoubleTapToExit(value);
  }

  @override
  Future<bool> getMaskSensitiveInfo() async {
    final maskSensitiveInfo = await dataSource.getMaskSensitiveInfo();
    return maskSensitiveInfo;
  }

  @override
  Future<bool> setMaskSensitiveInfo(bool value) async {
    return dataSource.setMaskSensitiveInfo(value);
  }

  @override
  Future<String> getLastSelectedServer() async {
    final lastSelectedServer = await dataSource.getLastSelectedServer();
    return lastSelectedServer;
  }

  @override
  Future<bool> setLastSelectedServer(String tautulliId) async {
    return dataSource.setLastSelectedServer(tautulliId);
  }

  @override
  Future<String> getStatsType() async {
    final statsType = await dataSource.getStatsType();
    return statsType;
  }

  @override
  Future<bool> setStatsType(String statsType) async {
    return dataSource.setStatsType(statsType);
  }

  @override
  Future<String> getYAxis() async {
    final yAxis = await dataSource.getYAxis();
    return yAxis;
  }

  @override
  Future<bool> setYAxis(String yAxis) async {
    return dataSource.setYAxis(yAxis);
  }

  @override
  Future<String> getUsersSort() async {
    final usersSort = await dataSource.getUsersSort();
    return usersSort;
  }

  @override
  Future<bool> setUsersSort(String usersSort) async {
    return dataSource.setUsersSort(usersSort);
  }

  @override
  Future<bool> getOneSignalBannerDismissed() async {
    final oneSignalBannerDismissed =
        await dataSource.getOneSignalBannerDismissed();
    return oneSignalBannerDismissed;
  }

  @override
  Future<bool> setOneSignalBannerDismissed(bool value) async {
    return dataSource.setOneSignalBannerDismissed(value);
  }

  @override
  Future<bool> getOneSignalConsented() async {
    final oneSignalConsented = await dataSource.getOneSignalConsented();
    return oneSignalConsented;
  }

  @override
  Future<bool> setOneSignalConsented(bool value) async {
    return dataSource.setOneSignalConsented(value);
  }

  @override
  Future<String> getLastAppVersion() async {
    final lastAppVersion = await dataSource.getLastAppVersion();
    return lastAppVersion;
  }

  @override
  Future<bool> setLastAppVersion(String lastAppVersion) async {
    return dataSource.setLastAppVersion(lastAppVersion);
  }

  @override
  Future<int> getLastReadAnnouncementId() async {
    final refreshRate = await dataSource.getLastReadAnnouncementId();
    return refreshRate;
  }

  @override
  Future<bool> setLastReadAnnouncementId(int value) async {
    return dataSource.setLastReadAnnouncementId(value);
  }

  @override
  Future<bool> getWizardCompleteStatus() async {
    final wizardCompleteStatus = await dataSource.getWizardCompleteStatus();
    return wizardCompleteStatus;
  }

  @override
  Future<bool> setWizardCompleteStatus(bool value) async {
    return dataSource.setWizardCompleteStatus(value);
  }

  @override
  Future<List<int>> getCustomCertHashList() async {
    final certHashList = await dataSource.getCustomCertHashList();
    return certHashList;
  }

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return dataSource.setCustomCertHashList(certHashList);
  }

  @override
  Future<bool> getIosLocalNetworkPermissionPrompted() async {
    final iOSLocalNetworkPermissionPrompted =
        await dataSource.getIosLocalNetworkPermissionPrompted();
    return iOSLocalNetworkPermissionPrompted;
  }

  @override
  Future<bool> setIosLocalNetworkPermissionPrompted(bool value) async {
    return dataSource.setIosLocalNetworkPermissionPrompted(value);
  }

  @override
  Future<bool> getGraphTipsShown() async {
    final graphTipsShown = await dataSource.getGraphTipsShown();
    return graphTipsShown;
  }

  @override
  Future<bool> setGraphTipsShown(bool value) async {
    return dataSource.setGraphTipsShown(value);
  }

  @override
  Future<bool> getIosNotificationPermissionDeclined() async {
    final iosNotificationPermissionDeclined =
        await dataSource.getIosNotificationPermissionDeclined();
    return iosNotificationPermissionDeclined;
  }

  @override
  Future<bool> setIosNotificationPermissionDeclined(bool value) async {
    return dataSource.setIosNotificationPermissionDeclined(value);
  }
}
