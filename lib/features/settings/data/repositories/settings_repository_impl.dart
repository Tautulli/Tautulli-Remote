import 'package:meta/meta.dart';

import '../../../../core/database/data/datasources/database.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/connection_address_helper.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final ConnectionAddressHelper connectionAddressHelper;

  SettingsRepositoryImpl({
    @required this.connectionAddressHelper,
  });

  @override
  Future addServer({
    @required String primaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
  }) async {
    final connectionMap =
        connectionAddressHelper.parse(primaryConnectionAddress);
    ServerModel server = ServerModel(
      primaryConnectionAddress: primaryConnectionAddress,
      primaryConnectionProtocol: connectionMap['protocol'],
      primaryConnectionDomain: connectionMap['domain'],
      primaryConnectionUser: connectionMap['user'],
      primaryConnectionPassword: connectionMap['password'],
      deviceToken: deviceToken,
      tautulliId: tautulliId,
      plexName: plexName,
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
  }) async {
    final primaryConnectionMap =
        connectionAddressHelper.parse(primaryConnectionAddress);
    final secondaryConnectionMap =
        connectionAddressHelper.parse(secondaryConnectionAddress);
    ServerModel server = ServerModel(
      id: id,
      primaryConnectionAddress: primaryConnectionAddress,
      primaryConnectionProtocol: primaryConnectionMap['protocol'],
      primaryConnectionDomain: primaryConnectionMap['domain'],
      primaryConnectionUser: primaryConnectionMap['user'],
      primaryConnectionPassword: primaryConnectionMap['password'],
      secondaryConnectionAddress: secondaryConnectionAddress,
      secondaryConnectionProtocol: secondaryConnectionMap['protocol'],
      secondaryConnectionDomain: secondaryConnectionMap['domain'],
      secondaryConnectionUser: secondaryConnectionMap['user'],
      secondaryConnectionPassword: secondaryConnectionMap['password'],
      deviceToken: deviceToken,
      tautulliId: tautulliId,
      plexName: plexName,
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
        connectionAddressHelper.parse(primaryConnectionAddress);
    final Map<String, dynamic> dbConnectionAddressMap = {
      'primary_connection_address': primaryConnectionAddress,
      'primary_connection_protocol': connectionMap['protocol'],
      'primary_connection_domain': connectionMap['domain'],
      'primary_connection_user': connectionMap['user'],
      'primary_connection_password': connectionMap['password']
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
        connectionAddressHelper.parse(secondaryConnectionAddress);
    final Map<String, dynamic> dbConnectionAddressMap = {
      'secondary_connection_address': secondaryConnectionAddress,
      'secondary_connection_protocol': connectionMap['protocol'],
      'secondary_connection_domain': connectionMap['domain'],
      'secondary_connection_user': connectionMap['user'],
      'secondary_connection_password': connectionMap['password']
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
}
