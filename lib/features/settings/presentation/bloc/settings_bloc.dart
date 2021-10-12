// @dart=2.9

import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiver/strings.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/connection_address_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../onesignal/data/datasources/onesignal_data_source.dart';
import '../../domain/entities/tautulli_settings_general.dart';
import '../../domain/usecases/register_device.dart';
import '../../domain/usecases/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

SettingsBloc _settingsBlocCache;

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Settings settings;
  final RegisterDevice registerDevice;
  final OneSignalDataSource onesignal;
  final Logging logging;

  SettingsBloc({
    @required this.settings,
    @required this.registerDevice,
    @required this.onesignal,
    @required this.logging,
  }) : super(SettingsInitial());

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    final currentState = state;

    if (event is SettingsLoad) {
      _settingsBlocCache = event.settingsBloc;

      yield SettingsLoadInProgress();
      yield* _fetchAndYieldSettings();
      yield* _checkForServerChanges(settingsBloc: _settingsBlocCache);
    }
    if (currentState is SettingsLoadSuccess) {
      if (event is SettingsAddServer) {
        logging.info(
          'Settings: Saving server details for ${event.plexName}',
        );

        final primaryConnectionMap = ConnectionAddressHelper.parse(
          event.primaryConnectionAddress,
        );
        final secondaryConnectionMap = ConnectionAddressHelper.parse(
          event.secondaryConnectionAddress,
        );
        ServerModel server = ServerModel(
          sortIndex: currentState.serverList.length,
          primaryConnectionAddress: event.primaryConnectionAddress,
          primaryConnectionProtocol: primaryConnectionMap['protocol'],
          primaryConnectionDomain: primaryConnectionMap['domain'],
          primaryConnectionPath: primaryConnectionMap['path'],
          secondaryConnectionAddress: event.secondaryConnectionAddress,
          secondaryConnectionProtocol: secondaryConnectionMap['protocol'],
          secondaryConnectionDomain: secondaryConnectionMap['domain'],
          secondaryConnectionPath: secondaryConnectionMap['path'],
          deviceToken: event.deviceToken,
          tautulliId: event.tautulliId,
          plexName: event.plexName,
          plexIdentifier: event.plexIdentifier,
          primaryActive: true,
          onesignalRegistered: event.onesignalRegistered,
          plexPass: event.plexPass,
          customHeaders: event.headers,
        );

        await settings.addServer(server: server);

        // Fetch just added server in order to get DB ID
        server = await settings.getServerByTautulliId(server.tautulliId);

        // Use spreading to create an entirely new list so the bloc updates
        List<ServerModel> updatedList = [...currentState.serverList];

        updatedList.add(server);
        if (updatedList.length > 1) {
          updatedList.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
        }

        yield currentState.copyWith(serverList: updatedList);
        yield* _checkForServerChanges(settingsBloc: _settingsBlocCache);
      }
      if (event is SettingsUpdateServer) {
        logging.info(
          'Settings: Updating server details for ${event.plexName}',
        );

        final primaryConnectionMap = ConnectionAddressHelper.parse(
          event.primaryConnectionAddress,
        );
        final secondaryConnectionMap = ConnectionAddressHelper.parse(
          event.secondaryConnectionAddress,
        );

        List<ServerModel> updatedList = [...currentState.serverList];

        final int index = currentState.serverList.indexWhere(
          (server) => server.id == event.id,
        );

        updatedList[index] = currentState.serverList[index].copyWith(
          id: event.id,
          sortIndex: event.sortIndex,
          primaryConnectionAddress: event.primaryConnectionAddress,
          primaryConnectionProtocol: primaryConnectionMap['protocol'],
          primaryConnectionDomain: primaryConnectionMap['domain'],
          primaryConnectionPath: primaryConnectionMap['path'],
          secondaryConnectionAddress: event.secondaryConnectionAddress,
          secondaryConnectionProtocol: secondaryConnectionMap['protocol'],
          secondaryConnectionDomain: secondaryConnectionMap['domain'],
          secondaryConnectionPath: secondaryConnectionMap['path'],
          deviceToken: event.deviceToken,
          tautulliId: event.tautulliId,
          plexName: event.plexName,
          plexIdentifier: event.plexIdentifier,
          primaryActive: true,
          onesignalRegistered: event.onesignalRegistered,
          plexPass: event.plexPass,
          dateFormat: event.dateFormat,
          timeFormat: event.timeFormat,
          customHeaders: event.headers,
        );

        await settings.updateServerById(
          server: updatedList[index],
        );

        yield currentState.copyWith(serverList: updatedList);
      }
      if (event is SettingsDeleteServer) {
        logging.info(
          'Settings: Deleting server ${event.plexName}',
        );

        await settings.deleteServer(event.id);

        // Use spreading to create an entirely new list so the bloc updates
        List<ServerModel> updatedList = [...currentState.serverList];

        final int index = updatedList.indexWhere(
          (server) => server.id == event.id,
        );
        updatedList.removeAt(index);

        yield currentState.copyWith(serverList: updatedList);
      }
      if (event is SettingsUpdatePrimaryConnection) {
        logging.info(
          'Settings: Updating primary connection address for ${event.plexName}',
        );

        final connectionMap = ConnectionAddressHelper.parse(
          event.primaryConnectionAddress,
        );

        await settings.updatePrimaryConnection(
          id: event.id,
          primaryConnectionInfo: {
            'primary_connection_address': event.primaryConnectionAddress,
            'primary_connection_protocol': connectionMap['protocol'],
            'primary_connection_domain': connectionMap['domain'],
            'primary_connection_path': connectionMap['path'],
          },
        );

        final int index = currentState.serverList.indexWhere(
          (server) => server.id == event.id,
        );

        List<ServerModel> updatedList = [...currentState.serverList];

        updatedList[index] = currentState.serverList[index].copyWith(
          primaryConnectionAddress: event.primaryConnectionAddress,
          primaryConnectionProtocol: connectionMap['protocol'],
          primaryConnectionDomain: connectionMap['domain'],
          primaryConnectionPath: connectionMap['path'],
        );

        yield currentState.copyWith(serverList: updatedList);
      }
      if (event is SettingsUpdateSecondaryConnection) {
        logging.info(
          'Settings: Updating secondary connection address for ${event.plexName}',
        );

        final connectionMap = ConnectionAddressHelper.parse(
          event.secondaryConnectionAddress,
        );

        await settings.updateSecondaryConnection(
          id: event.id,
          secondaryConnectionInfo: {
            'secondary_connection_address': event.secondaryConnectionAddress,
            'secondary_connection_protocol': connectionMap['protocol'],
            'secondary_connection_domain': connectionMap['domain'],
            'secondary_connection_path': connectionMap['path'],
          },
        );

        final int index = currentState.serverList.indexWhere(
          (server) => server.id == event.id,
        );

        List<ServerModel> updatedList = [...currentState.serverList];

        updatedList[index] = currentState.serverList[index].copyWith(
          secondaryConnectionAddress: event.secondaryConnectionAddress,
          secondaryConnectionProtocol: connectionMap['protocol'],
          secondaryConnectionDomain: connectionMap['domain'],
          secondaryConnectionPath: connectionMap['path'],
        );

        yield currentState.copyWith(serverList: updatedList);
      }
      if (event is SettingsUpdatePrimaryActive) {
        await settings.updatePrimaryActive(
          tautulliId: event.tautulliId,
          primaryActive: event.primaryActive,
        );

        final int index = currentState.serverList.indexWhere(
          (server) => server.tautulliId == event.tautulliId,
        );

        List<ServerModel> updatedList = [...currentState.serverList];

        updatedList[index] = currentState.serverList[index].copyWith(
          primaryActive: event.primaryActive,
        );
        yield currentState.copyWith(serverList: updatedList);
      }
      if (event is SettingsAddCustomHeader) {
        final int index = currentState.serverList.indexWhere(
          (server) => server.tautulliId == event.tautulliId,
        );

        List<ServerModel> updatedList = [...currentState.serverList];

        List<CustomHeaderModel> customHeaders = [
          ...updatedList[index].customHeaders
        ];

        if (event.basicAuth) {
          final currentIndex = customHeaders.indexWhere(
            (header) => header.key == 'Authorization',
          );

          final String base64Value =
              base64Encode(utf8.encode('${event.key}:${event.value}'));

          if (currentIndex == -1) {
            customHeaders.add(
              CustomHeaderModel(
                key: 'Authorization',
                value: 'Basic $base64Value',
              ),
            );
          } else {
            customHeaders[currentIndex] = CustomHeaderModel(
              key: 'Authorization',
              value: 'Basic $base64Value',
            );
          }
        } else {
          if (event.previousKey != null) {
            final oldIndex = customHeaders.indexWhere(
              (header) => header.key == event.previousKey,
            );

            customHeaders[oldIndex] = CustomHeaderModel(
              key: event.key,
              value: event.value,
            );
          } else {
            final currentIndex = customHeaders.indexWhere(
              (header) => header.key == event.key,
            );

            if (currentIndex == -1) {
              customHeaders.add(
                CustomHeaderModel(
                  key: event.key,
                  value: event.value,
                ),
              );
            } else {
              customHeaders[currentIndex] = CustomHeaderModel(
                key: event.key,
                value: event.value,
              );
            }
          }
        }

        await settings.updateCustomHeaders(
          tautulliId: event.tautulliId,
          customHeaders: customHeaders,
        );

        updatedList[index] = currentState.serverList[index].copyWith(
          customHeaders: customHeaders,
        );
        yield currentState.copyWith(serverList: updatedList);
      }
      if (event is SettingsRemoveCustomHeader) {
        final int index = currentState.serverList.indexWhere(
          (server) => server.tautulliId == event.tautulliId,
        );

        List<ServerModel> updatedList = [...currentState.serverList];

        List<CustomHeaderModel> customHeaders = [
          ...updatedList[index].customHeaders
        ];

        customHeaders.removeWhere((header) => header.key == event.key);

        await settings.updateCustomHeaders(
          tautulliId: event.tautulliId,
          customHeaders: customHeaders,
        );

        updatedList[index] = currentState.serverList[index].copyWith(
          customHeaders: customHeaders,
        );
        yield currentState.copyWith(serverList: updatedList);
      }
      if (event is SettingsUpdateSortIndex) {
        List<ServerModel> updatedServerList = currentState.serverList;
        ServerModel movedServer = updatedServerList.removeAt(event.oldIndex);
        updatedServerList.insert(event.newIndex, movedServer);

        yield currentState.copyWith(
          serverList: updatedServerList,
          sortChanged: '${movedServer.id}:${event.oldIndex}:${event.newIndex}',
        );

        await settings.updateServerSort(
          serverId: movedServer.id,
          oldIndex: event.oldIndex,
          newIndex: event.newIndex,
        );
      }
      if (event is SettingsUpdateServerTimeout) {
        logging.info(
          'Settings: Updating server timeout to ${event.timeout}s',
        );

        await settings.setServerTimeout(event.timeout);
        yield currentState.copyWith(serverTimeout: event.timeout);
      }
      if (event is SettingsUpdateRefreshRate) {
        final String refreshRateString =
            event.refreshRate != 0 ? '${event.refreshRate}s' : 'disabled';

        logging.info(
          'Settings: Updating refresh rate to $refreshRateString',
        );

        await settings.setRefreshRate(event.refreshRate);
        yield currentState.copyWith(refreshRate: event.refreshRate);
      }
      if (event is SettingsUpdateDoubleTapToExit) {
        logging.info(
          event.value
              ? 'Settings: Double Tap To Exit enabled'
              : 'Settings: Double Tap To Exit disabled',
        );

        await settings.setDoubleTapToExit(event.value);
        yield currentState.copyWith(doubleTapToExit: event.value);
      }
      if (event is SettingsUpdateMaskSensitiveInfo) {
        logging.info(
          event.value
              ? 'Settings: Mask Sensitive Info enabled'
              : 'Settings: Mask Sensitive Info disabled',
        );

        await settings.setMaskSensitiveInfo(event.value);
        yield currentState.copyWith(maskSensitiveInfo: event.value);
      }
      if (event is SettingsUpdateLastSelectedServer) {
        await settings.setLastSelectedServer(event.tautulliId);
        yield currentState.copyWith(lastSelectedServer: event.tautulliId);
      }
      if (event is SettingsUpdateStatsType) {
        await settings.setStatsType(event.statsType);
        yield currentState.copyWith(statsType: event.statsType);
      }
      if (event is SettingsUpdateYAxis) {
        await settings.setYAxis(event.yAxis);
        yield currentState.copyWith(yAxis: event.yAxis);
      }
      if (event is SettingsUpdateUsersSort) {
        await settings.setUsersSort(event.usersSort);
        yield currentState.copyWith(usersSort: event.usersSort);
      }
      if (event is SettingsUpdateOneSignalBannerDismiss) {
        if (event.dismiss) {
          logging.info('Settings: OneSignal banner dismissed');
        }

        await settings.setOneSignalBannerDismissed(event.dismiss);
        yield currentState.copyWith(oneSignalBannerDismissed: event.dismiss);
      }
      if (event is SettingsUpdateLastAppVersion) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        await settings.setLastAppVersion(packageInfo.version);
      }
      if (event is SettingsUpdateWizardCompleteStatus) {
        await settings.setWizardCompleteStatus(event.complete);
      }
      if (event is SettingsUpdateIosLocalNetworkPermissionPrompted) {
        if (event.prompted) {
          logging.info('Settings: Prompted for iOS local network permission');
        }
        await settings.setIosLocalNetworkPermissionPrompted(event.prompted);
        yield currentState.copyWith(
          iosLocalNetworkPermissionPrompted: event.prompted,
        );
      }
      if (event is SettingsUpdateGraphTipsShown) {
        await settings.setGraphTipsShown(event.shown);
        yield currentState.copyWith(graphTipsShown: event.shown);
      }
    }
  }

  Stream<SettingsState> _fetchAndYieldSettings() async* {
    final serverList = await settings.getAllServers();
    final serverTimeout = await settings.getServerTimeout();
    final refreshRate = await settings.getRefreshRate();
    final doubleTapToExit =
        Platform.isAndroid ? await settings.getDoubleTapToExit() : false;
    final maskSensitiveInfo = await settings.getMaskSensitiveInfo();
    final lastSelectedServer = await settings.getLastSelectedServer();
    final statsType = await settings.getStatsType();
    final yAxis = await settings.getYAxis();
    final usersSort = await settings.getUsersSort();
    final oneSignalBannerDismissed =
        await settings.getOneSignalBannerDismissed();
    final iosLocalNetworkPermissionPrompted =
        await settings.getIosLocalNetworkPermissionPrompted();
    final graphTipsShown = await settings.getGraphTipsShown();

    if (serverList.length > 1) {
      serverList.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
    }

    yield SettingsLoadSuccess(
      serverList: serverList,
      serverTimeout: serverTimeout ?? 15,
      refreshRate: refreshRate ?? 0,
      doubleTapToExit: doubleTapToExit ?? false,
      maskSensitiveInfo: maskSensitiveInfo ?? false,
      lastSelectedServer: lastSelectedServer,
      statsType: statsType ?? 'plays',
      yAxis: yAxis ?? 'plays',
      usersSort: usersSort ?? 'friendly_name|asc',
      oneSignalBannerDismissed: oneSignalBannerDismissed ?? false,
      iosLocalNetworkPermissionPrompted:
          iosLocalNetworkPermissionPrompted ?? false,
      graphTipsShown: graphTipsShown ?? false,
    );
  }

  Stream<SettingsState> _checkForServerChanges({
    @required SettingsBloc settingsBloc,
  }) async* {
    final serverList = await settings.getAllServers();

    for (ServerModel server in serverList) {
      await _serverInformation(
        server: server,
        settingsBloc: settingsBloc,
      ).then((settingsMap) {
        if (settingsMap['needsUpdate']) {
          add(
            SettingsUpdateServer(
              id: server.id,
              sortIndex: server.sortIndex,
              primaryConnectionAddress: server.primaryConnectionAddress,
              secondaryConnectionAddress: server.secondaryConnectionAddress,
              deviceToken: server.deviceToken,
              tautulliId: server.tautulliId,
              plexName: settingsMap['pmsName'],
              plexIdentifier: settingsMap['pmsIdentifier'],
              plexPass: settingsMap['plexPass'],
              dateFormat: settingsMap['dateFormat'],
              timeFormat: settingsMap['timeFormat'],
              onesignalRegistered: settingsMap['onesignalRegistered'],
            ),
          );
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
      'onesignalRegistered': server.onesignalRegistered,
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

    // If OneSignal User ID exists but server flag is false trigger a device
    // register and signal to update server flag
    if (isNotEmpty(await onesignal.userId) && !server.onesignalRegistered) {
      final failureOrRegisterDevice = await registerDevice(
        connectionProtocol: server.primaryActive
            ? server.primaryConnectionProtocol
            : server.secondaryConnectionProtocol,
        connectionDomain: server.primaryActive
            ? server.primaryConnectionDomain
            : server.secondaryConnectionDomain,
        connectionPath: server.primaryActive
            ? server.primaryConnectionPath
            : server.secondaryConnectionPath,
        deviceToken: server.deviceToken,
        headers: server.customHeaders,
        trustCert: false,
      );
      failureOrRegisterDevice.fold(
        (failure) {
          logging.error(
            'Settings: Failed to update registration with OneSignal User ID for ${server.plexName}',
          );
        },
        (registeredData) {
          logging.info(
            'Settings: Updating registration with OneSignal User ID for ${server.plexName}',
          );

          settingsMap['onesignalRegistered'] = true;
          settingsMap['needsUpdate'] = true;
        },
      );
    }

    return settingsMap;
  }
}
