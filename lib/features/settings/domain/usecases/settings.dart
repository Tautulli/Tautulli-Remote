import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/models/register_device_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/connection_address_model.dart';
import '../../data/models/custom_header_model.dart';
import '../repositories/settings_repository.dart';

class Settings {
  final SettingsRepository repository;

  Settings({required this.repository});

  /// Inserts the provided `ServerModel` into the database.
  ///
  /// Returns the ID of the last inserted row;
  Future<int> addServer(ServerModel server) async {
    return await repository.addServer(server);
  }

  /// Returns a list of `ServerModel` with all servers in the database.
  ///
  /// List will be empty if there are no servers.
  Future<List<ServerModel>> getAllServers() async {
    return await repository.getAllServers();
  }

  /// Returns a `ServerModel` for the corresponding Tautulli ID.
  ///
  /// Returns null if no server is found.
  Future<ServerModel?> getServerByTautulliId(String tautulliId) async {
    return await repository.getServerByTautulliId(tautulliId);
  }

  /// Updates the server with `id` using the information in
  /// `ConnectionAddressModel`.
  Future<int> updateConnectionInfo({
    required int id,
    required ConnectionAddressModel connectionAddress,
  }) async {
    return await repository.updateConnectionInfo(
      id: id,
      connectionAddress: connectionAddress,
    );
  }

  /// Updates the primary active state of the server with `tautulliId`
  ///
  /// Primary Active is used to determine if the primary connection address is
  /// active or not.
  Future<int> updatePrimaryActive({
    required String tautulliId,
    required bool primaryActive,
  }) async {
    return await repository.updatePrimaryActive(
      tautulliId: tautulliId,
      primaryActive: primaryActive,
    );
  }

  /// Updates the server with the provided `ServerModel` data.
  Future<int> updateServer(ServerModel server) async {
    return await repository.updateServer(server);
  }

  /// Updates the server sort by taking the server with provided `serverId` and
  ///moving it from `oldIndex` to `newIndex`.
  Future<void> updateServerSort({
    required int serverId,
    required int oldIndex,
    required int newIndex,
  }) async {
    return await repository.updateServerSort(
      serverId: serverId,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
  }

  /// Returns a list of user approved certificate hashes.
  ///
  /// Used for communicating with servers that could not be authenticated by
  /// any of the built in trusted root certificates.
  ///
  /// If no value is store returns an empty list.
  Future<List<int>> getCustomCertHashList() async {
    return await repository.getCustomCertHashList();
  }

  /// Sets the list of approved custom cert hashes.
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return await repository.setCustomCertHashList(certHashList);
  }

  /// Returns if exiting the app should require two sequential back actions.
  ///
  /// If no value is stored returns `false`.
  Future<bool> getDoubleTapToExit() async {
    return await repository.getDoubleTapToExit();
  }

  /// Sets if exiting the app should require two sequential back actions.
  Future<bool> setDoubleTapToExit(bool value) async {
    return await repository.setDoubleTapToExit(value);
  }

  /// Returns if the app should mask sensitive info.
  ///
  /// If no value is stored returns `false`.
  Future<bool> getMaskSensitiveInfo() async {
    return await repository.getMaskSensitiveInfo();
  }

  /// Sets if the app should mask sensitive info.
  Future<bool> setMaskSensitiveInfo(bool value) async {
    return await repository.setMaskSensitiveInfo(value);
  }

  /// Returns if the OneSignal Banner has been dismissed when determining if
  /// it should be displayed.
  ///
  /// If no value is stored returns `false`.
  Future<bool> getOneSignalBannerDismissed() async {
    return await repository.getOneSignalBannerDismissed();
  }

  /// Sets if the OneSignal banner has been manually dismissed.
  Future<bool> setOneSignalBannerDismissed(bool value) async {
    return await repository.setOneSignalBannerDismissed(value);
  }

  /// Returns if the user has consented to OneSignal.
  ///
  /// Used to account for issues where updating OneSignal clears out the
  /// consent status.
  ///
  /// If no value is stored returns `false`.
  Future<bool> getOneSignalConsented() async {
    return await repository.getOneSignalConsented();
  }

  /// Sets if OneSignal data privacy has been consented to.
  Future<bool> setOneSignalConsented(bool value) async {
    return await repository.setOneSignalConsented(value);
  }

  /// Returns the refresh rate used for auto refreshing activity.
  ///
  /// If no value is stored returns `0`.
  Future<int> getRefreshRate() async {
    return await repository.getRefreshRate();
  }

  /// Set the refresh rate used when automatically updating the activity.
  Future<bool> setRefreshRate(int value) async {
    return await repository.setRefreshRate(value);
  }

  /// How long to wait in seconds before timing out the server connection.
  ///
  /// If no value is stored returns `15`.
  Future<int> getServerTimeout() async {
    return await repository.getServerTimeout();
  }

  /// Sets the time to wait in seconds before timing out the server connection.
  Future<bool> setServerTimeout(int value) async {
    return await repository.setServerTimeout(value);
  }

  /// Used to register with a Tautulli server.
  ///
  /// When successful returns a `RegisterDeviceModel` containing response data
  /// as well as a bool to indicate the active primary connection address.
  ///
  /// Set `trustCert` to true to add the certificate's hash to a list of user
  /// trusted certificates that could not be authenticated by
  /// any of the built in trusted root certificates.
  Future<Either<Failure, Tuple2<RegisterDeviceModel, bool>>> registerDevice({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    List<CustomHeaderModel>? customHeaders,
    bool trustCert = false,
  }) async {
    return await repository.registerDevice(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
      customHeaders: customHeaders,
      trustCert: trustCert,
    );
  }
}
