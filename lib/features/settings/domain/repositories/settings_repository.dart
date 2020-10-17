import 'package:meta/meta.dart';

import '../../../../core/database/data/models/server_model.dart';

abstract class SettingsRepository {
  Future addServer({
    @required String primaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
    @required bool primaryActive,
    @required bool plexPass,
  });

  Future deleteServer(int id);

  Future updateServer(ServerModel server);

  Future updateServerById({
    @required int id,
    @required String primaryConnectionAddress,
    @required String secondaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
    @required bool primaryActive,
    @required bool plexPass,
  });

  Future<List<ServerModel>> getAllServers();

  Future<ServerModel> getServer(int id);

  Future getServerByTautulliId(String tautulliId);

  Future updatePrimaryConnection({
    @required int id,
    @required String primaryConnectionAddress,
  });

  Future updateSecondaryConnection({
    @required int id,
    @required String secondaryConnectionAddress,
  });

  Future updateDeviceToken({
    @required int id,
    @required String deviceToken,
  });

  Future getPrimaryActive(String tautulliId);

  Future updatePrimaryActive({
    @required String tautulliId,
    @required bool primaryActive,
  });

  Future<int> getServerTimeout();

  Future<bool> setServerTimeout(int value);

  Future<int> getRefreshRate();

  Future<bool> setRefreshRate(int value);

  Future<String> getLastSelectedServer();

  Future<bool> setLastSelectedServer(String tautulliId);
}
