import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../entities/plex_server_info.dart';

abstract class SettingsRepository {
  Future addServer({
    @required String primaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
    @required String plexIdentifier,
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
    @required String plexIdentifier,
    @required bool primaryActive,
    @required bool plexPass,
    @required String dateFormat,
    @required String timeFormat,
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

  Future<Either<Failure, PlexServerInfo>> getPlexServerInfo(String tautulliId);

  Future<Either<Failure, Map<String, dynamic>>> getTautulliSettings(
    String tautulliId,
  );

  Future<int> getServerTimeout();

  Future<bool> setServerTimeout(int value);

  Future<int> getRefreshRate();

  Future<bool> setRefreshRate(int value);

  Future<bool> getMaskSensitiveInfo();

  Future<bool> setMaskSensitiveInfo(bool value);

  Future<String> getLastSelectedServer();

  Future<bool> setLastSelectedServer(String tautulliId);

  Future<String> getStatsType();

  Future<bool> setStatsType(String statsType);
}
