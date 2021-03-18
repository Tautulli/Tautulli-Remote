import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:package_info/package_info.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/tautulli_settings_general.dart';
import '../../domain/usecases/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

SettingsBloc _settingsBlocCache;

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
      _settingsBlocCache = event.settingsBloc;

      yield SettingsLoadInProgress();
      yield* _fetchAndYieldSettings();
      yield* _checkForServerChanges(settingsBloc: _settingsBlocCache);
    }
    if (event is SettingsAddServer) {
      logging.info(
        'Settings: Saving server details for ${event.plexName}',
      );

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
      yield* _checkForServerChanges(settingsBloc: _settingsBlocCache);
    }
    if (event is SettingsUpdateServer) {
      logging.info(
        'Settings: Updating server details for ${event.plexName}',
      );

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
      logging.info(
        'Settings: Deleting server ${event.plexName}',
      );

      await settings.deleteServer(event.id);
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdatePrimaryConnection) {
      logging.info(
        'Settings: Updating primary connection address for ${event.plexName}',
      );

      await settings.updatePrimaryConnection(
        id: event.id,
        primaryConnectionAddress: event.primaryConnectionAddress.trim(),
      );
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateSecondaryConnection) {
      logging.info(
        'Settings: Updating secondary connection address for ${event.plexName}',
      );

      await settings.updateSecondaryConnection(
        id: event.id,
        secondaryConnectionAddress: event.secondaryConnectionAddress.trim(),
      );
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdatePrimaryActive) {
      await settings.updatePrimaryActive(
        tautulliId: event.tautulliId,
        primaryActive: event.primaryActive,
      );
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateDeviceToken) {
      logging.info(
        'Settings: Updating device token for ${event.plexName}',
      );

      await settings.updateDeviceToken(
        id: event.id,
        deviceToken: event.deviceToken.trim(),
      );
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateServerTimeout) {
      logging.info(
        'Settings: Updating server timeout to ${event.timeout}s',
      );

      await settings.setServerTimeout(event.timeout);
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateRefreshRate) {
      final String refreshRateString =
          event.refreshRate != null ? '${event.refreshRate}s' : 'disabled';

      logging.info(
        'Settings: Updating refresh rate to $refreshRateString',
      );

      await settings.setRefreshRate(event.refreshRate);
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateDoubleTapToExit) {
      logging.info(
        event.value
            ? 'Settings: Double Tap To Exit enabled'
            : 'Settings: Double Tap To Exit disabled',
      );

      await settings.setDoubleTapToExit(event.value);
      yield* _fetchAndYieldSettings();
    }
    if (event is SettingsUpdateMaskSensitiveInfo) {
      logging.info(
        event.value
            ? 'Settings: Mask Sensitive Info enabled'
            : 'Settings: Mask Sensitive Info disabled',
      );

      await settings.setMaskSensitiveInfo(event.value);
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
    if (event is SettingsUpdateLastAppVersion) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      await settings.setLastAppVersion(packageInfo.version);
      yield* _fetchAndYieldSettings();
    }
  }

  Stream<SettingsState> _fetchAndYieldSettings() async* {
    final serverList = await settings.getAllServers();
    final serverTimeout = await settings.getServerTimeout();
    final refreshRate = await settings.getRefreshRate();
    final doubleTapToExit = await settings.getDoubleTapToExit();
    final maskSensitiveInfo = await settings.getMaskSensitiveInfo();
    final lastSelectedServer = await settings.getLastSelectedServer();
    final statsType = await settings.getStatsType();

    yield SettingsLoadSuccess(
      serverList: serverList,
      serverTimeout: serverTimeout,
      refreshRate: refreshRate,
      doubleTapToExit: doubleTapToExit ?? false,
      maskSensitiveInfo: maskSensitiveInfo ?? false,
      lastSelectedServer: lastSelectedServer,
      statsType: statsType,
    );
  }

  Stream<SettingsState> _checkForServerChanges({
    @required SettingsBloc settingsBloc,
  }) async* {
    final serverList = await settings.getAllServers();

    for (ServerModel server in serverList) {
      _serverInformation(
        server: server,
        settingsBloc: settingsBloc,
      ).then((settingsMap) {
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

  Future<Map<String, dynamic>> _serverInformation({
    @required ServerModel server,
    @required SettingsBloc settingsBloc,
  }) async {
    Map<String, dynamic> settingsMap = {
      'needsUpdate': false,
      'plexPass': null,
      'pmsName': null,
      'pmsIdentifier': null,
      'dateFormat': null,
      'timeFormat': null,
    };

    // Check for changes to plexPass or pmsName
    final failureOrPlexServerInfo = await settings.getPlexServerInfo(
      tautulliId: server.tautulliId,
      settingsBloc: settingsBloc,
    );
    failureOrPlexServerInfo.fold(
      (failure) {
        logging.error(
          'Settings: Failed to fetch Plex server info for ${server.tautulliId}',
        );
      },
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
    final failureOrTautulliSettings = await settings.getTautulliSettings(
      tautulliId: server.tautulliId,
      settingsBloc: settingsBloc,
    );
    failureOrTautulliSettings.fold(
      (failure) {
        logging.error(
          'Settings: Failed to fetch Tautulli settings for ${server.tautulliId}',
        );
      },
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
