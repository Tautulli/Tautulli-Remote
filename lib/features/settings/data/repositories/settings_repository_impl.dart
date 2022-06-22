import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/models/plex_info_model.dart';
import '../../../../core/api/tautulli/models/register_device_model.dart';
import '../../../../core/api/tautulli/models/tautulli_general_settings_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../../../core/types/graph_y_axis.dart';
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
  Future<Either<Failure, Tuple2<TautulliGeneralSettingsModel, bool>>>
      getTautulliSettings(String tautulliId) async {
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
  // Custom Cert Hash List
  @override
  Future<String> getActiveServerId() async {
    return await dataSource.getActiveServerId();
  }

  @override
  Future<bool> setActiveServerId(String value) async {
    return await dataSource.setActiveServerId(value);
  }

  // Custom Cert Hash List
  @override
  Future<List<int>> getCustomCertHashList() async {
    return await dataSource.getCustomCertHashList();
  }

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return await dataSource.setCustomCertHashList(certHashList);
  }

  // Double Back To Exit
  @override
  Future<bool> getDoubleBackToExit() async {
    return await dataSource.getDoubleBackToExit();
  }

  @override
  Future<bool> setDoubleBackToExit(bool value) async {
    return await dataSource.setDoubleBackToExit(value);
  }

  // Graphs Time Range
  @override
  Future<int> getGraphTimeRange() async {
    return await dataSource.getGraphTimeRange();
  }

  @override
  Future<bool> setGraphTimeRange(int value) async {
    return await dataSource.setGraphTimeRange(value);
  }

  // Graph Tips Shown
  @override
  Future<bool> getGraphTipsShown() async {
    return await dataSource.getGraphTipsShown();
  }

  @override
  Future<bool> setGraphTipsShown(bool value) async {
    return await dataSource.setGraphTipsShown(value);
  }

  // Graph Y Axis
  @override
  Future<GraphYAxis> getGraphYAxis() async {
    return await dataSource.getGraphYAxis();
  }

  @override
  Future<bool> setGraphYAxis(GraphYAxis value) async {
    return await dataSource.setGraphYAxis(value);
  }

  // Last App Version
  @override
  Future<String> getLastAppVersion() async {
    return await dataSource.getLastAppVersion();
  }

  @override
  Future<bool> setLastAppVersion(String value) async {
    return await dataSource.setLastAppVersion(value);
  }

  // Last Read Announcement ID
  @override
  Future<int> getLastReadAnnouncementId() async {
    return await dataSource.getLastReadAnnouncementId();
  }

  @override
  Future<bool> setLastReadAnnouncementId(int value) async {
    return await dataSource.setLastReadAnnouncementId(value);
  }

  // Mask Sensitive Info
  @override
  Future<bool> getMaskSensitiveInfo() async {
    return await dataSource.getMaskSensitiveInfo();
  }

  @override
  Future<bool> setMaskSensitiveInfo(bool value) async {
    return await dataSource.setMaskSensitiveInfo(value);
  }

  // OneSignal Banner Dismissed
  @override
  Future<bool> getOneSignalBannerDismissed() async {
    return await dataSource.getOneSignalBannerDismissed();
  }

  @override
  Future<bool> setOneSignalBannerDismissed(bool value) async {
    return await dataSource.setOneSignalBannerDismissed(value);
  }

  // OneSignal Consented
  @override
  Future<bool> getOneSignalConsented() async {
    return await dataSource.getOneSignalConsented();
  }

  @override
  Future<bool> setOneSignalConsented(bool value) async {
    return await dataSource.setOneSignalConsented(value);
  }

  // Refresh Rate
  @override
  Future<int> getRefreshRate() async {
    return await dataSource.getRefreshRate();
  }

  @override
  Future<bool> setRefreshRate(int value) async {
    return await dataSource.setRefreshRate(value);
  }

  // Secret
  @override
  Future<bool> getSecret() async {
    return await dataSource.getSecret();
  }

  @override
  Future<bool> setSecret(bool value) async {
    return await dataSource.setSecret(value);
  }

  // Server Timeout
  @override
  Future<int> getServerTimeout() async {
    return await dataSource.getServerTimeout();
  }

  @override
  Future<bool> setServerTimeout(int value) async {
    return await dataSource.setServerTimeout(value);
  }

  // User Sort
  @override
  Future<String> getUsersSort() async {
    return await dataSource.getUsersSort();
  }

  @override
  Future<bool> setUsersSort(String value) async {
    return await dataSource.setUsersSort(value);
  }

  // Wizard Complete
  @override
  Future<bool> getWizardComplete() async {
    return await dataSource.getWizardComplete();
  }

  @override
  Future<bool> setWizardComplete(bool value) async {
    return await dataSource.setWizardComplete(value);
  }
}
