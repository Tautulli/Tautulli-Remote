import 'package:meta/meta.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../repositories/settings_repository.dart';

class Settings {
  final SettingsRepository repository;

  Settings({@required this.repository});

  Future addServer({
    @required String primaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
    @required bool primaryActive,
    @required bool plexPass,
  }) {
    return repository.addServer(
      primaryConnectionAddress: primaryConnectionAddress,
      deviceToken: deviceToken,
      tautulliId: tautulliId,
      plexName: plexName,
      primaryActive: primaryActive,
      plexPass: plexPass,
    );
  }

  Future deleteServer(int id) {
    return repository.deleteServer(id);
  }

  Future updateServer(ServerModel server) {
    return repository.updateServer(server);
  }

  Future updateServerById({
    @required int id,
    @required String primaryConnectionAddress,
    @required String secondaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
    @required bool primaryActive,
    @required bool plexPass,
  }) {
    return repository.updateServerById(
      id: id,
      primaryConnectionAddress: primaryConnectionAddress,
      secondaryConnectionAddress: secondaryConnectionAddress,
      deviceToken: deviceToken,
      tautulliId: tautulliId,
      plexName: plexName,
      primaryActive: primaryActive,
      plexPass: plexPass,
    );
  }

  Future<List<ServerModel>> getAllServers() async {
    return await repository.getAllServers();
  }

  Future getServer(int id) async {
    return await repository.getServer(id);
  }

  Future getServerByTautulliId(String tautulliId) async {
    return await repository.getServerByTautulliId(tautulliId);
  }

  Future updatePrimaryConnection({
    @required int id,
    @required String primaryConnectionAddress,
  }) {
    return repository.updatePrimaryConnection(
      id: id,
      primaryConnectionAddress: primaryConnectionAddress,
    );
  }

  Future updateSecondaryConnection({
    @required int id,
    @required String secondaryConnectionAddress,
  }) {
    return repository.updateSecondaryConnection(
      id: id,
      secondaryConnectionAddress: secondaryConnectionAddress,
    );
  }

  Future updateDeviceToken({
    @required int id,
    @required String deviceToken,
  }) {
    return repository.updateDeviceToken(
      id: id,
      deviceToken: deviceToken,
    );
  }

  Future getPrimaryActive(String tautulliId) async {
    return await repository.getPrimaryActive(tautulliId);
  }

  Future updatePrimaryActive({
    @required String tautulliId,
    @required bool primaryActive,
  }) {
    return repository.updatePrimaryActive(
      tautulliId: tautulliId,
      primaryActive: primaryActive,
    );
  }

  Future<int> getServerTimeout() async {
    return await repository.getServerTimeout();
  }

  Future<bool> setServerTimeout(int value) async {
    return repository.setServerTimeout(value);
  }

  Future<int> getRefreshRate() async {
    return await repository.getRefreshRate();
  }

  Future<bool> setRefreshRate(int value) async {
    return repository.setRefreshRate(value);
  }

  Future<String> getLastSelectedServer() async {
    return await repository.getLastSelectedServer();
  }

  Future<bool> setLastSelectedServer(String tautulliId) async {
    return repository.setLastSelectedServer(tautulliId);
  }
}
