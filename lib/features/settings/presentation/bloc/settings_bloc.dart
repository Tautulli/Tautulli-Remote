import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/usecases/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Settings settings;
  final Logging logging;

  SettingsBloc({
    @required this.settings,
    @required this.logging,
  }) : super(SettingsInitial());

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsLoad) {
      yield* _mapSettingsLoadToState();
    }
    if (event is SettingsAddServer) {
      yield* _mapSettingsAddServerToState(
        primaryConnectionAddress: event.primaryConnectionAddress,
        deviceToken: event.deviceToken,
        tautulliId: event.tautulliId,
        plexName: event.plexName,
        plexPass: event.plexPass,
      );
    }
    if (event is SettingsUpdateServer) {
      yield* _mapSettingsUpdateServerToState(
        id: event.id,
        primaryConnectionAddress: event.primaryConnectionAddress,
        secondaryConnectionAddress: event.secondaryConnectionAddress,
        deviceToken: event.deviceToken,
        tautulliId: event.tautulliId,
        plexName: event.plexName,
        plexPass: event.plexPass,
      );
    }
    if (event is SettingsDeleteServer) {
      yield* _mapSettingsDeleteServerToState(id: event.id);
    }
    if (event is SettingsUpdatePrimaryConnection) {
      yield* _mapSettingsUpdatePrimaryConnectionToState(
        id: event.id,
        primaryConnectionAddress: event.primaryConnectionAddress,
      );
    }
    if (event is SettingsUpdateSecondaryConnection) {
      yield* _mapSettingsUpdateSecondaryConnectionToState(
        id: event.id,
        secondaryConnectionAddress: event.secondaryConnectionAddress,
      );
    }
    if (event is SettingsUpdateDeviceToken) {
      yield* _mapSettingsUpdateDeviceTokenToState(
        id: event.id,
        deviceToken: event.deviceToken,
      );
    }
    if (event is SettingsUpdateServerTimeout) {
      yield* _mapSettingsUpdateServerTimeoutToState(
        timeout: event.timeout,
      );
    }
    if (event is SettingsUpdateRefreshRate) {
      yield* _mapSettingsUpdateRefreshRateToState(
        refreshRate: event.refreshRate,
      );
    }
    if (event is SettingsUpdateLastSelectedServer) {
      yield* _mapSettingsUpdateLastSelectedServerToState(
        tautulliId: event.tautulliId,
      );
    }
  }

  Stream<SettingsState> _mapSettingsLoadToState() async* {
    yield SettingsLoadInProgress();
    yield* _fetchAndYieldSettings();
    yield* _checkForServerChanges();
  }

  Stream<SettingsState> _mapSettingsAddServerToState({
    @required String primaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
    @required bool plexPass,
  }) async* {
    logging.info('Settings: Saving server details');
    await settings.addServer(
      primaryConnectionAddress: primaryConnectionAddress,
      deviceToken: deviceToken,
      tautulliId: tautulliId,
      plexName: plexName,
      primaryActive: true,
      plexPass: plexPass,
    );
    yield* _fetchAndYieldSettings();
  }

  Stream<SettingsState> _mapSettingsUpdateServerToState({
    @required int id,
    @required String primaryConnectionAddress,
    @required String secondaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
    @required bool plexPass,
  }) async* {
    logging.info('Settings: Updating server details');
    await settings.updateServerById(
      id: id,
      primaryConnectionAddress: primaryConnectionAddress,
      secondaryConnectionAddress: secondaryConnectionAddress,
      deviceToken: deviceToken,
      tautulliId: tautulliId,
      plexName: plexName,
      primaryActive: true,
      plexPass: plexPass,
    );
    yield* _fetchAndYieldSettings();
  }

  Stream<SettingsState> _mapSettingsDeleteServerToState({
    @required int id,
  }) async* {
    logging.info('Settings: Deleting server');
    await settings.deleteServer(id);
    yield* _fetchAndYieldSettings();
  }

  Stream<SettingsState> _mapSettingsUpdatePrimaryConnectionToState({
    @required int id,
    @required String primaryConnectionAddress,
  }) async* {
    logging.info('Settings: Updating primary connection address');
    await settings.updatePrimaryConnection(
      id: id,
      primaryConnectionAddress: primaryConnectionAddress.trim(),
    );
    yield* _fetchAndYieldSettings();
  }

  Stream<SettingsState> _mapSettingsUpdateSecondaryConnectionToState({
    @required int id,
    @required String secondaryConnectionAddress,
  }) async* {
    logging.info('Settings: Updating secondary connection address');
    await settings.updateSecondaryConnection(
      id: id,
      secondaryConnectionAddress: secondaryConnectionAddress.trim(),
    );
    yield* _fetchAndYieldSettings();
  }

  Stream<SettingsState> _mapSettingsUpdateDeviceTokenToState({
    @required int id,
    @required String deviceToken,
  }) async* {
    logging.info('Settings: Updating device token');
    await settings.updateDeviceToken(
      id: id,
      deviceToken: deviceToken.trim(),
    );
    yield* _fetchAndYieldSettings();
  }

  Stream<SettingsState> _mapSettingsUpdateServerTimeoutToState({
    @required int timeout,
  }) async* {
    logging.info('Settings: Updating server timeout to ${timeout}s');
    await settings.setServerTimeout(timeout);
    yield* _fetchAndYieldSettings();
  }

  Stream<SettingsState> _mapSettingsUpdateRefreshRateToState({
    @required int refreshRate,
  }) async* {
    final String refreshRateString =
        refreshRate != null ? '${refreshRate}s' : 'disabled';
    logging.info('Settings: Updating server timeout to $refreshRateString');

    await settings.setRefreshRate(refreshRate);
    yield* _fetchAndYieldSettings();
  }

  Stream<SettingsState> _mapSettingsUpdateLastSelectedServerToState({
    @required String tautulliId,
  }) async* {
    await settings.setLastSelectedServer(tautulliId);
    yield* _fetchAndYieldSettings();
  }

  Stream<SettingsState> _fetchAndYieldSettings() async* {
    final serverList = await settings.getAllServers();
    final serverTimeout = await settings.getServerTimeout();
    final refreshRate = await settings.getRefreshRate();
    final lastSelectedServer = await settings.getLastSelectedServer();

    yield SettingsLoadSuccess(
      serverList: serverList,
      serverTimeout: serverTimeout,
      refreshRate: refreshRate,
      lastSelectedServer: lastSelectedServer,
    );
  }

  Stream<SettingsState> _checkForServerChanges() async* {
    final serverList = await settings.getAllServers();

    for (ServerModel server in serverList) {
      settings.getPlexServerInfo(server.tautulliId).then(
        (failureOrPlexServerInfo) {
          return failureOrPlexServerInfo.fold(
            (failure) => null,
            (plexServerInfo) {
              bool plexPass;
              switch (plexServerInfo.pmsPlexpass) {
                case (0):
                  plexPass = false;
                  break;
                case (1):
                  plexPass = true;
                  break;
              }

              if (server.plexName != plexServerInfo.pmsName ||
                  server.plexPass != plexPass) {
                add(SettingsUpdateServer(
                  id: server.id,
                  primaryConnectionAddress: server.primaryConnectionAddress,
                  secondaryConnectionAddress: server.secondaryConnectionAddress,
                  deviceToken: server.deviceToken,
                  tautulliId: server.tautulliId,
                  plexName: plexServerInfo.pmsName,
                  plexPass: plexPass,
                ));
              }
            },
          );
        },
      );
    }
  }
}
