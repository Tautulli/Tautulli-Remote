import 'package:meta/meta.dart';
import 'package:validators/sanitizers.dart';

import '../../../../core/database/data/datasources/database.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/connection_address_helper.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;

  SettingsRepositoryImpl({
    @required this.dataSource,
  });

  @override
  Future addServer({
    @required String primaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
    @required bool primaryActive,
    @required bool plexPass,
  }) async {
    final connectionMap =
        ConnectionAddressHelper.parse(primaryConnectionAddress);
    ServerModel server = ServerModel(
      primaryConnectionAddress: primaryConnectionAddress,
      primaryConnectionProtocol: connectionMap['protocol'],
      primaryConnectionDomain: connectionMap['domain'],
      primaryConnectionPath: connectionMap['path'],
      deviceToken: deviceToken,
      tautulliId: tautulliId,
      plexName: plexName,
      primaryActive: primaryActive,
      plexPass: plexPass,
    );
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
    @required int id,
    @required String primaryConnectionAddress,
    @required String secondaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
    @required bool primaryActive,
    @required bool plexPass,
  }) async {
    final primaryConnectionMap =
        ConnectionAddressHelper.parse(primaryConnectionAddress);
    final secondaryConnectionMap =
        ConnectionAddressHelper.parse(secondaryConnectionAddress);
    ServerModel server = ServerModel(
      id: id,
      primaryConnectionAddress: primaryConnectionAddress,
      primaryConnectionProtocol: primaryConnectionMap['protocol'],
      primaryConnectionDomain: primaryConnectionMap['domain'],
      primaryConnectionPath: primaryConnectionMap['path'],
      secondaryConnectionAddress: secondaryConnectionAddress,
      secondaryConnectionProtocol: secondaryConnectionMap['protocol'],
      secondaryConnectionDomain: secondaryConnectionMap['domain'],
      secondaryConnectionPath: secondaryConnectionMap['path'],
      deviceToken: deviceToken,
      tautulliId: tautulliId,
      plexName: plexName,
      primaryActive: primaryActive,
      plexPass: plexPass,
    );

    return await DBProvider.db.updateServerById(server);
  }

  @override
  Future<List<ServerModel>> getAllServers() async {
    List<ServerModel> settingsList = await DBProvider.db.getAllServers();

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
  Future updatePrimaryConnection({
    @required int id,
    @required String primaryConnectionAddress,
  }) async {
    final connectionMap =
        ConnectionAddressHelper.parse(primaryConnectionAddress);
    final Map<String, dynamic> dbConnectionAddressMap = {
      'primary_connection_address': primaryConnectionAddress,
      'primary_connection_protocol': connectionMap['protocol'],
      'primary_connection_domain': connectionMap['domain'],
      'primary_connection_path': connectionMap['path'],
    };
    return await DBProvider.db.updateConnection(
      id: id,
      dbConnectionAddressMap: dbConnectionAddressMap,
    );
  }

  @override
  Future updateSecondaryConnection({
    @required int id,
    @required String secondaryConnectionAddress,
  }) async {
    final connectionMap =
        ConnectionAddressHelper.parse(secondaryConnectionAddress);
    final Map<String, dynamic> dbConnectionAddressMap = {
      'secondary_connection_address': secondaryConnectionAddress,
      'secondary_connection_protocol': connectionMap['protocol'],
      'secondary_connection_domain': connectionMap['domain'],
      'secondary_connection_path': connectionMap['path'],
    };
    return await DBProvider.db.updateConnection(
      id: id,
      dbConnectionAddressMap: dbConnectionAddressMap,
    );
  }

  @override
  Future updateDeviceToken({
    @required int id,
    @required String deviceToken,
  }) async {
    return await DBProvider.db.updateDeviceToken(
      id: id,
      deviceToken: deviceToken,
    );
  }

  @override
  Future getPrimaryActive(String tautulliId) async {
    final int result = await DBProvider.db.getPrimaryActive(tautulliId);

    return toBoolean(result.toString());
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
  Future<String> getLastSelectedServer() async {
    final lastSelectedServer = await dataSource.getLastSelectedServer();
    return lastSelectedServer;
  }

  @override
  Future<bool> setLastSelectedServer(String tautulliId) async {
    return dataSource.setLastSelectedServer(tautulliId);
  }
}
