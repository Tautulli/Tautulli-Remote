import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/models/register_device_model.dart';
import '../../../../core/api/tautulli/tautulli_api.dart';
import '../../../../core/database/data/datasources/database.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/device_info/device_info.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/local_storage/local_storage.dart';
import '../../../../core/package_information/package_information.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../onesignal/data/datasources/onesignal_data_source.dart';
import '../models/connection_address_model.dart';
import '../models/custom_header_model.dart';

abstract class SettingsDataSource {
  //* Database Interactions
  Future<int> addServer(ServerModel server);

  Future<void> deleteServer(int id);

  Future<List<ServerModel>> getAllServers();

  Future<ServerModel?> getServerByTautulliId(String tautulliId);

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
  // Custom Cert Hash List
  Future<List<int>> getCustomCertHashList();
  Future<bool> setCustomCertHashList(List<int> certHashList);

  // Double Tap To Exit
  Future<bool> getDoubleTapToExit();
  Future<bool> setDoubleTapToExit(bool value);

  // Mask Sensitive Info
  Future<bool> getMaskSensitiveInfo();
  Future<bool> setMaskSensitiveInfo(bool value);

  // OneSignal Banner Dismissed
  Future<bool> getOneSignalBannerDismissed();
  Future<bool> setOneSignalBannerDismissed(bool value);

  // OneSignal Consented
  Future<bool> getOneSignalConsented();
  Future<bool> setOneSignalConsented(bool value);

  // Refresh Rate
  Future<int> getRefreshRate();
  Future<bool> setRefreshRate(int value);

  // Server Timeout
  Future<int> getServerTimeout();
  Future<bool> setServerTimeout(int value);

  //* Settings Actions
  Future<Tuple2<RegisterDeviceModel, bool>> registerDevice({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    List<CustomHeaderModel>? customHeaders,
    bool trustCert,
  });
}

const customCertHashList = 'customCertHashList';
const doubleTapToExit = 'doubleTapToExit';
const maskSensitiveInfo = 'maskSensitiveInfo';
const oneSignalBannerDismissed = 'oneSignalBannerDismissed';
const oneSignalConsented = 'oneSignalConsented';
const refreshRate = 'refreshRate';
const serverTimeout = 'serverTimeout';

class SettingsDataSourceImpl implements SettingsDataSource {
  final DeviceInfo deviceInfo;
  final LocalStorage localStorage;
  final PackageInformation packageInfo;
  final RegisterDevice registerDeviceApi;

  SettingsDataSourceImpl({
    required this.deviceInfo,
    required this.localStorage,
    required this.packageInfo,
    required this.registerDeviceApi,
  });

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

  // Double Tap To Exit
  @override
  Future<bool> getDoubleTapToExit() async {
    return Future.value(localStorage.getBool(doubleTapToExit) ?? false);
  }

  @override
  Future<bool> setDoubleTapToExit(bool value) {
    return localStorage.setBool(doubleTapToExit, value);
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

  // Server Timeout
  @override
  Future<int> getServerTimeout() async {
    return Future.value(localStorage.getInt(serverTimeout) ?? 15);
  }

  @override
  Future<bool> setServerTimeout(int value) {
    return localStorage.setInt(serverTimeout, value);
  }

  //* Settings Actions
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

    // If the response result is not success throw ServerException.
    if (result.value1['response']['result'] != 'success') {
      throw ServerException();
    }

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
}
