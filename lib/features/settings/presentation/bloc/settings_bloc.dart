import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/strings.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/manage_cache/manage_cache.dart';
import '../../../../core/types/protocol.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../data/models/app_settings_model.dart';
import '../../data/models/connection_address_model.dart';
import '../../data/models/custom_header_model.dart';
import '../../domain/usecases/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Logging logging;
  final ManageCache manageCache;
  final Settings settings;

  SettingsBloc({
    required this.logging,
    required this.manageCache,
    required this.settings,
  }) : super(SettingsInitial()) {
    on<SettingsAddServer>((event, emit) => _onSettingsAddServer(event, emit));
    on<SettingsClearCache>((event, emit) => _onSettingsClearCache(event, emit));
    on<SettingsLoad>((event, emit) => _onSettingsLoad(event, emit));
    on<SettingsUpdateConnectionInfo>(
      (event, emit) => _onSettingsUpdateConnectionInfo(event, emit),
    );
    on<SettingsUpdateDoubleTapToExit>(
      (event, emit) => _onSettingsUpdateDoubleTapToExit(event, emit),
    );
    on<SettingsUpdateMaskSensitiveInfo>(
      (event, emit) => _onSettingsUpdateMaskSensitiveInfo(event, emit),
    );
    on<SettingsUpdateOneSignalBannerDismiss>(
      (event, emit) => _onSettingsUpdateOneSignalBannerDismiss(event, emit),
    );
    on<SettingsUpdatePrimaryActive>(
      (event, emit) => _onSettingsUpdatePrimaryActive(event, emit),
    );
    on<SettingsUpdateRefreshRate>(
      (event, emit) => _onSettingsUpdateRefreshRate(event, emit),
    );
    on<SettingsUpdateServer>(
      (event, emit) => _onSettingsUpdateServer(event, emit),
    );
    on<SettingsUpdateServerSort>(
      (event, emit) => _onSettingsUpdateServerSort(event, emit),
    );
    on<SettingsUpdateServerTimeout>(
      (event, emit) => _onSettingsUpdateServerTimeout(event, emit),
    );
  }

  void _onSettingsAddServer(
    SettingsAddServer event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    logging.info(
      'Settings :: Saving server details for ${event.plexName}',
    );

    final ConnectionAddressModel primaryConnectionAddress =
        ConnectionAddressModel.fromConnectionAddress(
      primary: true,
      connectionAddress: event.primaryConnectionAddress,
    );

    ConnectionAddressModel secondaryConnectionAddress =
        const ConnectionAddressModel(primary: false);
    if (isNotBlank(event.secondaryConnectionAddress)) {
      secondaryConnectionAddress = ConnectionAddressModel.fromConnectionAddress(
        primary: false,
        connectionAddress: event.secondaryConnectionAddress!,
      );
    }

    ServerModel server = ServerModel(
      sortIndex: currentState.serverList.length,
      plexName: event.plexName,
      plexIdentifier: event.plexIdentifier,
      tautulliId: event.tautulliId,
      primaryConnectionAddress: primaryConnectionAddress.address!,
      primaryConnectionProtocol:
          primaryConnectionAddress.protocol?.toShortString() ?? 'http',
      primaryConnectionDomain: primaryConnectionAddress.domain!,
      primaryConnectionPath: primaryConnectionAddress.path,
      secondaryConnectionAddress: secondaryConnectionAddress.address,
      secondaryConnectionProtocol:
          secondaryConnectionAddress.protocol?.toShortString(),
      secondaryConnectionDomain: secondaryConnectionAddress.domain,
      secondaryConnectionPath: secondaryConnectionAddress.path,
      deviceToken: event.deviceToken,
      primaryActive: true,
      oneSignalRegistered: event.oneSignalRegistered,
      plexPass: event.plexPass,
      customHeaders: event.customHeaders ?? [],
    );

    final serverId = await settings.addServer(server);

    server = server.copyWith(id: serverId);

    List<ServerModel> updatedList = [...currentState.serverList];

    updatedList.add(server);

    if (updatedList.length > 1) {
      updatedList.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
    }

    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onSettingsClearCache(
    SettingsClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    manageCache.clearCache();
    logging.info(
      'Settings :: Image cache cleared',
    );
  }

  void _onSettingsLoad(
    SettingsLoad event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      SettingsInProgress(),
    );

    try {
      // Fetch settings
      final List<ServerModel> serverList = await settings.getAllServers();
      final AppSettingsModel appSettings = AppSettingsModel(
        doubleTapToExit: await settings.getDoubleTapToExit(),
        maskSensitiveInfo: await settings.getMaskSensitiveInfo(),
        oneSignalBannerDismissed: await settings.getOneSignalBannerDismissed(),
        oneSignalConsented: await settings.getOneSignalConsented(),
        serverTimeout: await settings.getServerTimeout(),
        refreshRate: await settings.getRefreshRate(),
      );

      emit(
        SettingsSuccess(
          serverList: serverList,
          appSettings: appSettings,
        ),
      );
    } catch (e) {
      logging.info(
        'Settings :: Failed to load settings [$e]',
      );

      emit(
        SettingsFailure(),
      );
    }
  }

  void _onSettingsUpdateConnectionInfo(
    SettingsUpdateConnectionInfo event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    final ConnectionAddressModel connectionAddress =
        ConnectionAddressModel.fromConnectionAddress(
      primary: event.primary,
      connectionAddress: event.connectionAddress,
    );

    await settings.updateConnectionInfo(
      id: event.server.id!,
      connectionAddress: connectionAddress,
    );

    final int index = currentState.serverList.indexWhere(
      (oldServer) => oldServer.id == event.server.id,
    );

    List<ServerModel> updatedList = [...currentState.serverList];

    if (event.primary) {
      updatedList[index] = currentState.serverList[index].copyWith(
        primaryConnectionAddress: connectionAddress.address,
        primaryConnectionProtocol: connectionAddress.protocol?.toShortString(),
        primaryConnectionDomain: connectionAddress.domain,
        primaryConnectionPath: connectionAddress.path,
      );
    } else {
      updatedList[index] = currentState.serverList[index].copyWith(
        secondaryConnectionAddress: connectionAddress.address,
        secondaryConnectionProtocol:
            connectionAddress.protocol?.toShortString(),
        secondaryConnectionDomain: connectionAddress.domain,
        secondaryConnectionPath: connectionAddress.path,
      );
    }

    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onSettingsUpdateDoubleTapToExit(
    SettingsUpdateDoubleTapToExit event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setDoubleTapToExit(event.doubleTapToExit);
    logging.info(
      'Settings :: Double Tap To Exit set to ${event.doubleTapToExit}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings
            .copyWith(doubleTapToExit: event.doubleTapToExit),
      ),
    );
  }

  void _onSettingsUpdateMaskSensitiveInfo(
    SettingsUpdateMaskSensitiveInfo event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setMaskSensitiveInfo(event.maskSensitiveInfo);
    logging.info(
      'Settings :: Mask Sensitive Info set to ${event.maskSensitiveInfo}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings
            .copyWith(maskSensitiveInfo: event.maskSensitiveInfo),
      ),
    );
  }

  void _onSettingsUpdateOneSignalBannerDismiss(
    SettingsUpdateOneSignalBannerDismiss event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setOneSignalBannerDismissed(event.dismiss);
    if (event.dismiss) {
      logging.info(
        'Settings :: OneSignal Banner Dismissed',
      );
    }

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings
            .copyWith(oneSignalBannerDismissed: event.dismiss),
      ),
    );
  }

  void _onSettingsUpdatePrimaryActive(
    SettingsUpdatePrimaryActive event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.updatePrimaryActive(
      tautulliId: event.tautulliId,
      primaryActive: event.primaryActive,
    );

    final int index = currentState.serverList.indexWhere(
      (oldServer) => oldServer.tautulliId == event.tautulliId,
    );

    List<ServerModel> updatedList = [...currentState.serverList];

    updatedList[index] = currentState.serverList[index].copyWith(
      primaryActive: event.primaryActive,
    );

    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onSettingsUpdateRefreshRate(
    SettingsUpdateRefreshRate event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setRefreshRate(event.refreshRate);
    logging.info(
      'Settings :: Activity Refresh Rate set to ${event.refreshRate}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          refreshRate: event.refreshRate,
        ),
      ),
    );
  }

  void _onSettingsUpdateServer(
    SettingsUpdateServer event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    logging.info(
      'Settings :: Updating server details for ${event.plexName}',
    );

    final ConnectionAddressModel primaryConnectionAddress =
        ConnectionAddressModel.fromConnectionAddress(
      primary: true,
      connectionAddress: event.primaryConnectionAddress,
    );

    final ConnectionAddressModel secondaryConnectionAddress =
        ConnectionAddressModel.fromConnectionAddress(
      primary: true,
      connectionAddress: event.secondaryConnectionAddress,
    );

    List<ServerModel> updatedList = [...currentState.serverList];

    final int index = currentState.serverList.indexWhere(
      (server) => server.id == event.id,
    );

    updatedList[index] = currentState.serverList[index].copyWith(
      id: event.id,
      sortIndex: event.sortIndex,
      primaryConnectionAddress: primaryConnectionAddress.address,
      primaryConnectionProtocol:
          primaryConnectionAddress.protocol?.toShortString(),
      primaryConnectionDomain: primaryConnectionAddress.domain,
      primaryConnectionPath: primaryConnectionAddress.path,
      secondaryConnectionAddress: secondaryConnectionAddress.address,
      secondaryConnectionProtocol:
          secondaryConnectionAddress.protocol?.toShortString(),
      secondaryConnectionDomain: secondaryConnectionAddress.domain,
      secondaryConnectionPath: secondaryConnectionAddress.path,
      deviceToken: event.deviceToken,
      tautulliId: event.tautulliId,
      plexName: event.plexName,
      plexIdentifier: event.plexIdentifier,
      primaryActive: true,
      oneSignalRegistered: event.oneSignalRegistered,
      plexPass: event.plexPass,
      dateFormat: event.dateFormat,
      timeFormat: event.timeFormat,
      customHeaders: event.customHeaders,
    );

    await settings.updateServer(updatedList[index]);

    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onSettingsUpdateServerSort(
    SettingsUpdateServerSort event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    List<ServerModel> updatedServerList = [...currentState.serverList];
    ServerModel movedServer = updatedServerList.removeAt(event.oldIndex);
    updatedServerList.insert(event.newIndex, movedServer);

    emit(
      currentState.copyWith(serverList: updatedServerList),
    );

    await settings.updateServerSort(
      serverId: event.serverId,
      oldIndex: event.oldIndex,
      newIndex: event.newIndex,
    );

    // Get Servers with updated sorts to keep state accurate
    updatedServerList = await settings.getAllServers();
    emit(
      currentState.copyWith(serverList: updatedServerList),
    );

    logging.info('Settings :: Updated server sort');
  }

  void _onSettingsUpdateServerTimeout(
    SettingsUpdateServerTimeout event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setServerTimeout(event.timeout);
    logging.info(
      'Settings :: Server Timeout set to ${event.timeout}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          serverTimeout: event.timeout,
        ),
      ),
    );
  }
}
