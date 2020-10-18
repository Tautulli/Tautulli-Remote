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
      yield SettingsLoadInProgress();
      yield* _fetchAndYieldSettings();
      yield* _checkForServerChanges();
    }
    if (event is SettingsAddServer) {
      logging.info('Settings: Saving server details');
      await settings.addServer(
        primaryConnectionAddress: event.primaryConnectionAddress,
        deviceToken: event.deviceToken,
        tautulliId: event.tautulliId,
        plexName: event.plexName,
        primaryActive: true,
        plexPass: event.plexPass,
      );
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateServer) {
      logging.info('Settings: Updating server details');
      await settings.updateServerById(
        id: event.id,
        primaryConnectionAddress: event.primaryConnectionAddress,
        secondaryConnectionAddress: event.secondaryConnectionAddress,
        deviceToken: event.deviceToken,
        tautulliId: event.tautulliId,
        plexName: event.plexName,
        primaryActive: true,
        plexPass: event.plexPass,
      );
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsDeleteServer) {
      logging.info('Settings: Deleting server');
      await settings.deleteServer(event.id);
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdatePrimaryConnection) {
      logging.info('Settings: Updating primary connection address');
      await settings.updatePrimaryConnection(
        id: event.id,
        primaryConnectionAddress: event.primaryConnectionAddress.trim(),
      );
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateSecondaryConnection) {
      logging.info('Settings: Updating secondary connection address');
      await settings.updateSecondaryConnection(
        id: event.id,
        secondaryConnectionAddress: event.secondaryConnectionAddress.trim(),
      );
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateDeviceToken) {
      logging.info('Settings: Updating device token');
      await settings.updateDeviceToken(
        id: event.id,
        deviceToken: event.deviceToken.trim(),
      );
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateServerTimeout) {
      logging.info('Settings: Updating server timeout to ${event.timeout}s');
      await settings.setServerTimeout(event.timeout);
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateRefreshRate) {
      final String refreshRateString =
          event.refreshRate != null ? '${event.refreshRate}s' : 'disabled';
      logging.info('Settings: Updating server timeout to $refreshRateString');

      await settings.setRefreshRate(event.refreshRate);
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateLastSelectedServer) {
      await settings.setLastSelectedServer(event.tautulliId);
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateStatsType) {
      await settings.setStatsType(event.statsType);
      yield* _fetchAndYieldSettings();
    }
  }

  Stream<SettingsState> _fetchAndYieldSettings() async* {
    final serverList = await settings.getAllServers();
    final serverTimeout = await settings.getServerTimeout();
    final refreshRate = await settings.getRefreshRate();
    final lastSelectedServer = await settings.getLastSelectedServer();
    final statsType = await settings.getStatsType();

    yield SettingsLoadSuccess(
      serverList: serverList,
      serverTimeout: serverTimeout,
      refreshRate: refreshRate,
      lastSelectedServer: lastSelectedServer,
      statsType: statsType,
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
