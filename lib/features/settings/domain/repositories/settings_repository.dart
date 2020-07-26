import 'package:meta/meta.dart';

import '../../../../core/database/data/models/server_model.dart';


abstract class SettingsRepository {
  Future addServer({
    @required String primaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
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
  });

  Future<List<ServerModel>> getAllServers();

  Future<ServerModel> getServer(int id);

  Future getServerByTautulliId(String tautulliId);

  Future getServerByPlexName(String plexName);

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
}
