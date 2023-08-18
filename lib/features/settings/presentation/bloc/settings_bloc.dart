import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../../../../core/api/tautulli/models/plex_info_model.dart';
import '../../../../core/api/tautulli/models/tautulli_general_settings_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/manage_cache/manage_cache.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../../../core/types/theme_enhancement_type.dart';
import '../../../../core/types/theme_type.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../data/models/app_settings_model.dart';
import '../../data/models/connection_address_model.dart';
import '../../data/models/custom_header_model.dart';
import '../../domain/usecases/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

const ServerModel blankServer = ServerModel(
  sortIndex: -1,
  plexName: '',
  plexIdentifier: '',
  tautulliId: '',
  primaryConnectionAddress: '',
  primaryConnectionProtocol: '',
  primaryConnectionDomain: '',
  deviceToken: '',
  primaryActive: true,
  oneSignalRegistered: false,
  plexPass: false,
  customHeaders: [],
);

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
    on<SettingsDeleteCustomHeader>(
      (event, emit) => _onSettingsDeleteCustomHeader(event, emit),
    );
    on<SettingsDeleteServer>(
      (event, emit) => _onSettingsDeleteServer(event, emit),
    );
    on<SettingsLoad>((event, emit) => _onSettingsLoad(event, emit));
    on<SettingsUpdateActiveServer>(
      (event, emit) => _onSettingsUpdateActiveServer(event, emit),
    );
    on<SettingsUpdateAppUpdateAvailable>(
      (event, emit) => _onSettingsUpdateAppUpdateAvailable(event, emit),
    );
    on<SettingsUpdateConnectionInfo>(
      (event, emit) => _onSettingsUpdateConnectionInfo(event, emit),
    );
    on<SettingsUpdateCustomHeaders>(
      (event, emit) => _onSettingsUpdateCustomHeaders(event, emit),
    );
    on<SettingsUpdateDoubleBackToExit>(
      (event, emit) => _onSettingsUpdateDoubleBackToExit(event, emit),
    );
    on<SettingsUpdateGraphTimeRange>(
      (event, emit) => _onSettingsUpdateGraphTimeRange(event, emit),
    );
    on<SettingsUpdateGraphTipsShown>(
      (event, emit) => _onSettingsUpdateGraphTipsShown(event, emit),
    );
    on<SettingsUpdateGraphYAxis>(
      (event, emit) => _onSettingsUpdateGraphYAxis(event, emit),
    );
    on<SettingsUpdateDisableImageBackgrounds>(
      (event, emit) => _onSettingsUpdateDisableImageBackgrounds(event, emit),
    );
    on<SettingsUpdateLibrariesSort>(
      (event, emit) => _onSettingsUpdateLibrariesSort(event, emit),
    );
    on<SettingsUpdateLibraryMediaFullRefresh>(
      (event, emit) => _onSettingsUpdateLibraryMediaFullRefresh(event, emit),
    );
    on<SettingsUpdateMaskSensitiveInfo>(
      (event, emit) => _onSettingsUpdateMaskSensitiveInfo(event, emit),
    );
    on<SettingsUpdateMultiserverActivity>(
      (event, emit) => _onSettingsUpdateMultiserverActivity(event, emit),
    );
    on<SettingsUpdateOneSignalConsented>(
      (event, emit) => _onSettingsUpdateOneSignalConsented(event, emit),
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
    on<SettingsUpdateSecret>(
      (event, emit) => _onSettingsUpdateSecret(event, emit),
    );
    on<SettingsUpdateServer>(
      (event, emit) => _onSettingsUpdateServer(event, emit),
    );
    on<SettingsUpdateServerPlexAndTautulliInfo>(
      (event, emit) => _onSettingsUpdateServerPlexAndTautulliInfo(event, emit),
    );
    on<SettingsUpdateServerSort>(
      (event, emit) => _onSettingsUpdateServerSort(event, emit),
    );
    on<SettingsUpdateServerTimeout>(
      (event, emit) => _onSettingsUpdateServerTimeout(event, emit),
    );
    on<SettingsUpdateStatisticsStatType>(
      (event, emit) => _onSettingsUpdateStatisticsStatType(event, emit),
    );
    on<SettingsUpdateStatisticsTimeRange>(
      (event, emit) => _onSettingsUpdateStatisticsTimeRange(event, emit),
    );
    on<SettingsUpdateTheme>(
      (event, emit) => _onSettingsUpdateTheme(event, emit),
    );
    on<SettingsUpdateThemeCustomColor>(
      (event, emit) => _onSettingsUpdateThemeCustomColor(event, emit),
    );
    on<SettingsUpdateThemeEnhancement>(
      (event, emit) => _onSettingsUpdateThemeEnhancement(event, emit),
    );
    on<SettingsUpdateThemeUseSystemColor>(
      (event, emit) => _onSettingsUpdateThemeUseSystemColor(event, emit),
    );
    on<SettingsUpdateUseAtkinsonHyperlegible>(
      (event, emit) => _onSettingsUpdateUseAtkinsonHyperlegible(event, emit),
    );
    on<SettingsUpdateUsersSort>(
      (event, emit) => _onSettingsUpdateUsersSort(event, emit),
    );
    on<SettingsUpdateWizardComplete>(
      (event, emit) => _onSettingsUpdateWizardComplete(event, emit),
    );
  }

  void _onSettingsAddServer(
    SettingsAddServer event,
    Emitter<SettingsState> emit,
  ) async {
    SettingsSuccess currentState = state as SettingsSuccess;

    final ConnectionAddressModel primaryConnectionAddress = ConnectionAddressModel.fromConnectionAddress(
      primary: true,
      connectionAddress: event.primaryConnectionAddress,
    );

    ConnectionAddressModel secondaryConnectionAddress = const ConnectionAddressModel(primary: false);
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
      primaryConnectionProtocol: primaryConnectionAddress.protocol?.toShortString() ?? 'http',
      primaryConnectionDomain: primaryConnectionAddress.domain!,
      primaryConnectionPath: primaryConnectionAddress.path,
      secondaryConnectionAddress: secondaryConnectionAddress.address,
      secondaryConnectionProtocol: secondaryConnectionAddress.protocol?.toShortString(),
      secondaryConnectionDomain: secondaryConnectionAddress.domain,
      secondaryConnectionPath: secondaryConnectionAddress.path,
      deviceToken: event.deviceToken,
      primaryActive: true,
      oneSignalRegistered: event.oneSignalRegistered,
      plexPass: event.plexPass,
      customHeaders: event.customHeaders ?? [],
    );

    final serverId = await settings.addServer(server);

    logging.info(
      "Settings :: Added server '${event.plexName}'",
    );

    server = server.copyWith(id: serverId);

    List<ServerModel> updatedList = [...currentState.serverList];

    // If server list is empty when adding a new server set the sever to active
    if (updatedList.isEmpty) {
      await settings.setActiveServerId(server.tautulliId);
      logging.debug("Settings :: Active server set to '${server.plexName}'");

      currentState = currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          activeServer: server,
        ),
      );

      emit(
        currentState,
      );
    }

    updatedList.add(server);

    if (updatedList.length > 1) {
      updatedList.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
    }

    emit(
      currentState.copyWith(serverList: updatedList),
    );

    _updateServerInfo(server: server);
  }

  void _onSettingsClearCache(
    SettingsClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    manageCache.clearCache();
    logging.info(
      'Settings :: App image cache cleared',
    );
  }

  void _onSettingsDeleteCustomHeader(
    SettingsDeleteCustomHeader event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    final int index = currentState.serverList.indexWhere(
      (server) => server.tautulliId == event.tautulliId,
    );

    List<ServerModel> updatedList = [...currentState.serverList];

    List<CustomHeaderModel> customHeaders = [...updatedList[index].customHeaders];

    customHeaders.removeWhere((header) => header.key == event.title);

    await settings.updateCustomHeaders(
      tautulliId: event.tautulliId,
      headers: customHeaders,
    );

    logging.info("Settings :: Removed '${event.title}' header");

    updatedList[index] = currentState.serverList[index].copyWith(
      customHeaders: customHeaders,
    );
    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onSettingsDeleteServer(
    SettingsDeleteServer event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    List<ServerModel> updatedList = [...currentState.serverList];

    final int index = updatedList.indexWhere(
      (server) => server.id == event.id,
    );
    updatedList.removeAt(index);

    // If server list is empty store empty string for activeServerId.

    // Else if the active server is being removed set the first server in
    // updatedList to be active.
    if (updatedList.isEmpty) {
      logging.debug(
        'Settings :: Last server has been deleted, clearing active server',
      );
      await settings.setActiveServerId('');
      emit(
        currentState.copyWith(
          appSettings: currentState.appSettings.copyWith(
            activeServer: blankServer,
          ),
        ),
      );
    } else if (currentState.appSettings.activeServer.id == event.id) {
      logging.debug(
        "Settings :: Active server has been deleted, setting '${updatedList[0].plexName}' as active server",
      );
      await settings.setActiveServerId(updatedList[0].tautulliId);
      emit(
        currentState.copyWith(
          appSettings: currentState.appSettings.copyWith(
            activeServer: updatedList[0],
          ),
        ),
      );
    }

    await settings.deleteServer(event.id);

    logging.info("Settings :: Deleted server '${event.plexName}'");

    // Delay item removal to avoid user noticing server page trying to display
    // after server is removed from the list
    //TODO: There has to be a better solution to this problem
    await Future.delayed(const Duration(milliseconds: 180));

    emit(
      currentState.copyWith(serverList: updatedList),
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
      String activeServerId = settings.getActiveServerId();

      // If active server ID is blank but server list isn't empty set the first
      // server to be the active server.
      if (activeServerId == '' && serverList.isNotEmpty) {
        activeServerId = serverList.first.tautulliId;
        await settings.setActiveServerId(activeServerId);
        logging.debug(
          "Settings :: No active server, setting '${serverList.first.plexName}' to active",
        );
      }

      final AppSettingsModel appSettings = AppSettingsModel(
        activeServer: activeServerId != ''
            ? serverList.firstWhere((server) => server.tautulliId == activeServerId)
            : serverList.isNotEmpty
                ? serverList.first
                : blankServer,
        appUpdateAvailable: settings.getAppUpdateAvailable(),
        disableImageBackgrounds: settings.getDisableImageBackgrounds(),
        doubleBackToExit: settings.getDoubleBackToExit(),
        graphTimeRange: settings.getGraphTimeRange(),
        graphTipsShown: settings.getGraphTipsShown(),
        graphYAxis: settings.getGraphYAxis(),
        librariesSort: settings.getLibrariesSort(),
        libraryMediaFullRefresh: settings.getLibraryMediaFullRefresh(),
        maskSensitiveInfo: settings.getMaskSensitiveInfo(),
        multiserverActivity: settings.getMultiserverActivity(),
        oneSignalBannerDismissed: settings.getOneSignalBannerDismissed(),
        oneSignalConsented: settings.getOneSignalConsented(),
        refreshRate: settings.getRefreshRate(),
        secret: settings.getSecret(),
        serverTimeout: settings.getServerTimeout(),
        statisticsStatType: settings.getStatisticsStatType(),
        statisticsTimeRange: settings.getStatisticsTimeRange(),
        theme: settings.getTheme(),
        themeCustomColor: settings.getThemeCustomColor(),
        themeEnhancement: settings.getThemeEnhancement(),
        themeUseSystemColor: settings.getThemeUseSystemColor(),
        useAtkinsonHyperlegible: settings.getUseAtkinsonHyperlegible(),
        usersSort: settings.getUsersSort(),
        wizardComplete: settings.getWizardComplete(),
      );

      emit(
        SettingsSuccess(
          serverList: serverList,
          appSettings: appSettings,
        ),
      );

      if (event.updateServerInfo) {
        for (ServerModel server in serverList) {
          _updateServerInfo(server: server);
        }
      }
    } catch (e) {
      logging.info(
        'Settings :: Failed to load settings [$e]',
      );

      emit(
        SettingsFailure(),
      );
    }
  }

  void _onSettingsUpdateActiveServer(
    SettingsUpdateActiveServer event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setActiveServerId(event.activeServer.tautulliId);
    logging.debug(
      "Settings :: Active server changed to '${event.activeServer.plexName}'",
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(activeServer: event.activeServer),
      ),
    );
  }

  void _onSettingsUpdateAppUpdateAvailable(
    SettingsUpdateAppUpdateAvailable event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setAppUpdateAvailable(event.appUpdateAvailable);

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(appUpdateAvailable: event.appUpdateAvailable),
      ),
    );
  }

  void _onSettingsUpdateConnectionInfo(
    SettingsUpdateConnectionInfo event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    final ConnectionAddressModel connectionAddress = ConnectionAddressModel.fromConnectionAddress(
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
        secondaryConnectionProtocol: connectionAddress.protocol?.toShortString(),
        secondaryConnectionDomain: connectionAddress.domain,
        secondaryConnectionPath: connectionAddress.path,
      );
    }

    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onSettingsUpdateCustomHeaders(
    SettingsUpdateCustomHeaders event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;
    String loggingMessage = 'Settings :: Header changed but logging missed it';

    final int index = currentState.serverList.indexWhere(
      (server) => server.tautulliId == event.tautulliId,
    );

    List<ServerModel> updatedList = [...currentState.serverList];

    List<CustomHeaderModel> customHeaders = [...updatedList[index].customHeaders];

    if (event.basicAuth) {
      final currentIndex = customHeaders.indexWhere(
        (header) => header.key == 'Authorization',
      );

      final String base64Value = base64Encode(
        utf8.encode('${event.title}:${event.subtitle}'),
      );

      if (currentIndex == -1) {
        customHeaders.add(
          CustomHeaderModel(
            key: 'Authorization',
            value: 'Basic $base64Value',
          ),
        );

        loggingMessage = "Settings :: Added 'Authorization' header";
      } else {
        customHeaders[currentIndex] = CustomHeaderModel(
          key: 'Authorization',
          value: 'Basic $base64Value',
        );

        loggingMessage = "Settings :: Updated 'Authorization' header";
      }
    } else {
      if (event.previousTitle != null) {
        final oldIndex = customHeaders.indexWhere(
          (header) => header.key == event.previousTitle,
        );

        customHeaders[oldIndex] = CustomHeaderModel(
          key: event.title,
          value: event.subtitle,
        );

        if (event.previousTitle != event.title) {
          loggingMessage = "Settings :: Replaced '${event.previousTitle}' header with '${event.title}'";
        } else {
          loggingMessage = "Settings :: Updated '${event.title}' header'";
        }
      } else {
        // No previous title means a new header is being added. We need to
        // check and make sure we don't end up with headers that have duplicate
        // keys/titles
        final currentIndex = customHeaders.indexWhere(
          (header) => header.key == event.title,
        );

        if (currentIndex == -1) {
          customHeaders.add(
            CustomHeaderModel(
              key: event.title,
              value: event.subtitle,
            ),
          );

          loggingMessage = "Settings :: Added '${event.title}' header";
        } else {
          customHeaders[currentIndex] = CustomHeaderModel(
            key: event.title,
            value: event.subtitle,
          );

          loggingMessage = "Settings :: Updated '${event.title}' header";
        }
      }
    }

    await settings.updateCustomHeaders(
      tautulliId: event.tautulliId,
      headers: customHeaders,
    );

    logging.info(loggingMessage);

    updatedList[index] = currentState.serverList[index].copyWith(
      customHeaders: customHeaders,
    );

    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onSettingsUpdateDisableImageBackgrounds(
    SettingsUpdateDisableImageBackgrounds event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setDisableImageBackgrounds(event.disableImageBackgrounds);
    logging.info(
      'Settings :: Disable Image Backgrounds set to ${event.disableImageBackgrounds}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          disableImageBackgrounds: event.disableImageBackgrounds,
        ),
      ),
    );
  }

  void _onSettingsUpdateDoubleBackToExit(
    SettingsUpdateDoubleBackToExit event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setDoubleBackToExit(event.doubleBackToExit);
    logging.info(
      'Settings :: Double Back To Exit set to ${event.doubleBackToExit}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(doubleBackToExit: event.doubleBackToExit),
      ),
    );
  }

  void _onSettingsUpdateGraphTimeRange(
    SettingsUpdateGraphTimeRange event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setGraphTimeRange(event.graphTimeRange);
    logging.info(
      'Settings :: Graph Time Range set to ${event.graphTimeRange}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(graphTimeRange: event.graphTimeRange),
      ),
    );
  }

  void _onSettingsUpdateGraphTipsShown(
    SettingsUpdateGraphTipsShown event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setGraphTipsShown(event.graphTipsShown);
    logging.info(
      'Settings :: Graph Tips Shown set to ${event.graphTipsShown}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(graphTipsShown: event.graphTipsShown),
      ),
    );
  }

  void _onSettingsUpdateGraphYAxis(
    SettingsUpdateGraphYAxis event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setGraphYAxis(event.graphYAxis);
    logging.info(
      'Settings :: Graph Y Axis set to ${event.graphYAxis}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(graphYAxis: event.graphYAxis),
      ),
    );
  }

  void _onSettingsUpdateLibrariesSort(
    SettingsUpdateLibrariesSort event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setLibrariesSort(event.librariesSort);
    logging.info(
      'Settings :: Libraries Sort set to ${event.librariesSort}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          librariesSort: event.librariesSort,
        ),
      ),
    );
  }

  void _onSettingsUpdateLibraryMediaFullRefresh(
    SettingsUpdateLibraryMediaFullRefresh event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setLibraryMediaFullRefresh(event.libraryMediaFullRefresh);
    logging.info(
      'Settings :: Library Media Full Refresh set to ${event.libraryMediaFullRefresh}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(libraryMediaFullRefresh: event.libraryMediaFullRefresh),
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
        appSettings: currentState.appSettings.copyWith(maskSensitiveInfo: event.maskSensitiveInfo),
      ),
    );
  }

  void _onSettingsUpdateMultiserverActivity(
    SettingsUpdateMultiserverActivity event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setMultiserverActivity(event.multiserverActivity);
    logging.info(
      'Settings :: Multiserver Activity set to ${event.multiserverActivity}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(multiserverActivity: event.multiserverActivity),
      ),
    );
  }

  void _onSettingsUpdateOneSignalConsented(
    SettingsUpdateOneSignalConsented event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setOneSignalConsented(event.consented);

    // Logging handled by OneSignalPrivacyBloc

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(oneSignalConsented: event.consented),
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
        appSettings: currentState.appSettings.copyWith(oneSignalBannerDismissed: event.dismiss),
      ),
    );
  }

  void _onSettingsUpdatePrimaryActive(
    SettingsUpdatePrimaryActive event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    final int index = currentState.serverList.indexWhere(
      (oldServer) => oldServer.tautulliId == event.tautulliId,
    );

    // Only update primary active if new value is different
    if (currentState.serverList[index].primaryActive != event.primaryActive) {
      await settings.updatePrimaryActive(
        tautulliId: event.tautulliId,
        primaryActive: event.primaryActive,
      );

      List<ServerModel> updatedList = [...currentState.serverList];

      updatedList[index] = currentState.serverList[index].copyWith(
        primaryActive: event.primaryActive,
      );

      emit(
        currentState.copyWith(serverList: updatedList),
      );
    }
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

  void _onSettingsUpdateSecret(
    SettingsUpdateSecret event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setSecret(event.secret);
    logging.info(
      'What is a man? A miserable little pile of secrets.',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          secret: event.secret,
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
      "Settings :: Updating server details for '${event.plexName}'",
    );

    final ConnectionAddressModel primaryConnectionAddress = ConnectionAddressModel.fromConnectionAddress(
      primary: true,
      connectionAddress: event.primaryConnectionAddress,
    );

    final ConnectionAddressModel secondaryConnectionAddress = ConnectionAddressModel.fromConnectionAddress(
      primary: false,
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
      primaryConnectionProtocol: primaryConnectionAddress.protocol?.toShortString(),
      primaryConnectionDomain: primaryConnectionAddress.domain,
      primaryConnectionPath: primaryConnectionAddress.path,
      secondaryConnectionAddress: secondaryConnectionAddress.address,
      secondaryConnectionProtocol: secondaryConnectionAddress.protocol != null ? secondaryConnectionAddress.protocol!.toShortString() : '',
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

  void _onSettingsUpdateServerPlexAndTautulliInfo(
    SettingsUpdateServerPlexAndTautulliInfo event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    List<ServerModel> updatedList = [...currentState.serverList];

    final int index = currentState.serverList.indexWhere(
      (server) => server.id == event.serverModel.id,
    );

    updatedList[index] = event.serverModel;

    await settings.updateServer(event.serverModel);

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

  void _updateServerInfo({
    required ServerModel server,
  }) async {
    String? plexName;
    String? plexIdentifier;
    bool? plexPass;
    String? dateFormat;
    String? timeFormat;

    final failureOrPlexInfo = await settings.getPlexInfo(server.tautulliId);
    final failureOrTautulliSettings = await settings.getTautulliSettings(
      server.tautulliId,
    );

    failureOrPlexInfo.fold(
      (failure) {
        logging.error(
          'Settings: Failed to fetch updated Plex info for ${server.plexName}',
        );
      },
      (response) {
        add(
          SettingsUpdatePrimaryActive(
            tautulliId: server.tautulliId,
            primaryActive: response.value2,
          ),
        );

        final PlexInfoModel results = response.value1;

        plexName = results.pmsName;
        plexIdentifier = results.pmsIdentifier;
        plexPass = results.pmsPlexpass;
      },
    );

    failureOrTautulliSettings.fold(
      (failure) {
        logging.error(
          'Settings: Failed to fetch updated Tautulli Settings for ${server.plexName}',
        );
      },
      (response) {
        add(
          SettingsUpdatePrimaryActive(
            tautulliId: server.tautulliId,
            primaryActive: response.value2,
          ),
        );

        final TautulliGeneralSettingsModel results = response.value1;

        dateFormat = results.dateFormat;
        timeFormat = results.timeFormat;
      },
    );

    ServerModel updatedServer = server.copyWith(
      plexName: plexName,
      plexIdentifier: plexIdentifier,
      plexPass: plexPass,
      dateFormat: dateFormat,
      timeFormat: timeFormat,
    );

    if (server != updatedServer) {
      logging.info(
        'Settings :: Updating Plex and Tautulli details for ${updatedServer.plexName}',
      );
      add(
        SettingsUpdateServerPlexAndTautulliInfo(serverModel: updatedServer),
      );
    }
  }

  void _onSettingsUpdateStatisticsStatType(
    SettingsUpdateStatisticsStatType event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setStatisticsStatType(event.statisticsStatType);
    logging.info(
      'Settings :: Statistics Stat Type set to ${event.statisticsStatType}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(statisticsStatType: event.statisticsStatType),
      ),
    );
  }

  void _onSettingsUpdateStatisticsTimeRange(
    SettingsUpdateStatisticsTimeRange event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setStatisticsTimeRange(event.statisticsTimeRange);
    logging.info(
      'Settings :: Statistics Time Range set to ${event.statisticsTimeRange}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(statisticsTimeRange: event.statisticsTimeRange),
      ),
    );
  }

  void _onSettingsUpdateTheme(
    SettingsUpdateTheme event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setTheme(event.themeType);
    logging.info(
      'Settings :: Theme set to ${event.themeType.themeName()}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          theme: event.themeType,
        ),
      ),
    );
  }

  void _onSettingsUpdateThemeCustomColor(
    SettingsUpdateThemeCustomColor event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setThemeCustomColor(event.color);
    logging.info(
      'Settings :: Theme Custom Color set to ${event.color}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          themeCustomColor: event.color,
        ),
      ),
    );
  }

  void _onSettingsUpdateThemeEnhancement(
    SettingsUpdateThemeEnhancement event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setThemeEnhancement(event.themeEnhancementType);
    logging.info(
      'Settings :: Theme Enhancement set to ${event.themeEnhancementType.name()}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          themeEnhancement: event.themeEnhancementType,
        ),
      ),
    );
  }

  void _onSettingsUpdateThemeUseSystemColor(
    SettingsUpdateThemeUseSystemColor event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setThemeUseSystemColor(event.useSystemColor);
    logging.info(
      'Settings :: Theme System Color set to ${event.useSystemColor}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          themeUseSystemColor: event.useSystemColor,
        ),
      ),
    );
  }

  void _onSettingsUpdateUseAtkinsonHyperlegible(
    SettingsUpdateUseAtkinsonHyperlegible event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setUseAtkinsonHyperlegible(event.useAtkinsonHyperlegible);
    logging.info(
      'Settings :: Use Atkinson Hyperlegible Font set to ${event.useAtkinsonHyperlegible}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          useAtkinsonHyperlegible: event.useAtkinsonHyperlegible,
        ),
      ),
    );
  }

  void _onSettingsUpdateUsersSort(
    SettingsUpdateUsersSort event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state as SettingsSuccess;

    await settings.setUsersSort(event.usersSort);
    logging.info(
      'Settings :: Users Sort set to ${event.usersSort}',
    );

    emit(
      currentState.copyWith(
        appSettings: currentState.appSettings.copyWith(
          usersSort: event.usersSort,
        ),
      ),
    );
  }

  void _onSettingsUpdateWizardComplete(
    SettingsUpdateWizardComplete event,
    Emitter<SettingsState> emit,
  ) async {
    await settings.setWizardComplete(event.wizardComplete);

    logging.info(
      'Settings :: Wizard complete',
    );
  }
}
