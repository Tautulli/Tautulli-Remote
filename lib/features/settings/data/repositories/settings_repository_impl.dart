import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/models/register_device_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
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

  //* Database Interactions
  @override
  Future<int> addServer(ServerModel server) async {
    return await dataSource.addServer(server);
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
  Future<List<int>> getCustomCertHashList() async {
    return await dataSource.getCustomCertHashList();
  }

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return await dataSource.setCustomCertHashList(certHashList);
  }

  // Double Tap To Exit
  @override
  Future<bool> getDoubleTapToExit() async {
    return await dataSource.getDoubleTapToExit();
  }

  @override
  Future<bool> setDoubleTapToExit(bool value) async {
    return await dataSource.setDoubleTapToExit(value);
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

  // Server Timeout
  @override
  Future<int> getServerTimeout() async {
    return await dataSource.getServerTimeout();
  }

  @override
  Future<bool> setServerTimeout(int value) async {
    return await dataSource.setServerTimeout(value);
  }

  //* Settings Actions
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
        final results = await dataSource.registerDevice(
          connectionProtocol: connectionProtocol,
          connectionDomain: connectionDomain,
          connectionPath: connectionPath,
          deviceToken: deviceToken,
          customHeaders: customHeaders,
          trustCert: trustCert,
        );

        return Right(results);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
