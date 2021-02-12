import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/tautulli_settings_general.dart';
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
        plexIdentifier: event.plexIdentifier,
        primaryActive: true,
        plexPass: event.plexPass,
      );
      yield* _fetchAndYieldSettings();
      yield* _checkForServerChanges();
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
        plexIdentifier: event.plexIdentifier,
        primaryActive: true,
        plexPass: event.plexPass,
        dateFormat: event.dateFormat,
        timeFormat: event.timeFormat,
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
      _serverInformation(server).then((settingsMap) {
        if (settingsMap['needsUpdate']) {
          add(SettingsUpdateServer(
            id: server.id,
            primaryConnectionAddress: server.primaryConnectionAddress,
            secondaryConnectionAddress: server.secondaryConnectionAddress,
            deviceToken: server.deviceToken,
            tautulliId: server.tautulliId,
            plexName: settingsMap['pmsName'],
            plexIdentifier: settingsMap['pmsIdentifier'],
            plexPass: settingsMap['plexPass'],
            dateFormat: settingsMap['dateFormat'],
            timeFormat: settingsMap['timeFormat'],
          ));
        }
      });
    }
  }

  Future<Map<String, dynamic>> _serverInformation(ServerModel server) async {
    Map<String, dynamic> settingsMap = {
      'needsUpdate': false,
      'plexPass': null,
      'pmsName': null,
      'pmsIdentifier': null,
      'dateFormat': null,
      'timeFormat': null,
    };

    // Check for changes to plexPass or pmsName
    final failureOrPlexServerInfo =
        await settings.getPlexServerInfo(server.tautulliId);
    failureOrPlexServerInfo.fold(
      (failure) => null,
      (plexServerInfo) {
        settingsMap['pmsName'] = plexServerInfo.pmsName;
        settingsMap['pmsIdentifier'] = plexServerInfo.pmsIdentifier;
        switch (plexServerInfo.pmsPlexpass) {
          case (0):
            settingsMap['plexPass'] = false;
            break;
          case (1):
            settingsMap['plexPass'] = true;
            break;
        }

        if (server.plexName != plexServerInfo.pmsName ||
            server.plexPass != settingsMap['plexPass'] ||
            server.plexIdentifier != plexServerInfo.pmsIdentifier) {
          settingsMap['needsUpdate'] = true;
        }
      },
    );

    // Check for changes to Tautulli Server settings
    final failureOrTautulliSettings =
        await settings.getTautulliSettings(server.tautulliId);
    failureOrTautulliSettings.fold(
      (failure) => null,
      (tautulliSettings) {
        final TautulliSettingsGeneral generalSettings =
            tautulliSettings['general'];
        settingsMap['dateFormat'] = generalSettings.dateFormat;
        settingsMap['timeFormat'] = generalSettings.timeFormat;

        if (server.dateFormat != settingsMap['dateFormat'] ||
            server.timeFormat != settingsMap['timeFormat']) {
          settingsMap['needsUpdate'] = true;
        }
      },
    );

    return settingsMap;
  }
}
