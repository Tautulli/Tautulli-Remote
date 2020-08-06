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
      yield* _mapSettingsLoadToState(settings);
    }
    if (event is SettingsAddServer) {
      yield* _mapSettingsAddServerToState(
        settings: settings,
        logging: logging,
        primaryConnectionAddress: event.primaryConnectionAddress,
        deviceToken: event.deviceToken,
        tautulliId: event.tautulliId,
        plexName: event.plexName,
      );
    }
    if (event is SettingsUpdateServer) {
      yield* _mapSettingsUpdateServerToState(
        settings: settings,
        logging: logging,
        id: event.id,
        primaryConnectionAddress: event.primaryConnectionAddress,
        secondaryConnectionAddress: event.secondaryConnectionAddress,
        deviceToken: event.deviceToken,
        tautulliId: event.tautulliId,
        plexName: event.plexName,
      );
    }
    if (event is SettingsDeleteServer) {
      yield* _mapSettingsDeleteServerToState(
          settings: settings, logging: logging, id: event.id);
    }
    if (event is SettingsUpdatePrimaryConnection) {
      yield* _mapSettingsUpdatePrimaryConnectionToState(
        settings: settings,
        logging: logging,
        id: event.id,
        primaryConnectionAddress: event.primaryConnectionAddress,
      );
    }
    if (event is SettingsUpdateSecondaryConnection) {
      yield* _mapSettingsUpdateSecondaryConnectionToState(
        settings: settings,
        logging: logging,
        id: event.id,
        secondaryConnectionAddress: event.secondaryConnectionAddress,
      );
    }
    if (event is SettingsUpdateDeviceToken) {
      yield* _mapSettingsUpdateDeviceTokenToState(
        settings: settings,
        logging: logging,
        id: event.id,
        deviceToken: event.deviceToken,
      );
    }
    if (event is SettingsUpdateServerTimeout) {
      yield* _mapSettingsUpdateServerTimeoutToState(
        settings: settings,
        logging: logging,
        timeout: event.timeout,
      );
    }
    if (event is SettingsUpdateRefreshRate) {
      yield* _mapSettingsSettingsUpdateRefreshRateToState(
        settings: settings,
        logging: logging,
        refreshRate: event.refreshRate,
      );
    }
  }

  Stream<SettingsState> _mapSettingsLoadToState(Settings settings) async* {
    yield SettingsLoadInProgress();
    yield* _fetchAndYieldSettings(settings);
  }

  Stream<SettingsState> _mapSettingsAddServerToState({
    @required Settings settings,
    @required Logging logging,
    @required String primaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
  }) async* {
    logging.info('Settings: Saving server details');
    await settings.addServer(
      primaryConnectionAddress: primaryConnectionAddress,
      deviceToken: deviceToken,
      tautulliId: tautulliId,
      plexName: plexName,
    );
    yield* _fetchAndYieldSettings(settings);
  }

  Stream<SettingsState> _mapSettingsUpdateServerToState({
    @required Settings settings,
    @required Logging logging,
    @required int id,
    @required String primaryConnectionAddress,
    @required String secondaryConnectionAddress,
    @required String deviceToken,
    @required String tautulliId,
    @required String plexName,
  }) async* {
    logging.info('Settings: Updating server details');
    await settings.updateServerById(
      id: id,
      primaryConnectionAddress: primaryConnectionAddress,
      secondaryConnectionAddress: secondaryConnectionAddress,
      deviceToken: deviceToken,
      tautulliId: tautulliId,
      plexName: plexName,
    );
    yield* _fetchAndYieldSettings(settings);
  }

  Stream<SettingsState> _mapSettingsDeleteServerToState({
    @required Logging logging,
    @required Settings settings,
    @required int id,
  }) async* {
    logging.info('Settings: Deleting server');
    await settings.deleteServer(id);
    yield* _fetchAndYieldSettings(settings);
  }

  Stream<SettingsState> _mapSettingsUpdatePrimaryConnectionToState({
    @required Logging logging,
    @required Settings settings,
    @required int id,
    @required String primaryConnectionAddress,
  }) async* {
    logging.info('Settings: Updating primary connection address');
    await settings.updatePrimaryConnection(
      id: id,
      primaryConnectionAddress: primaryConnectionAddress.trim(),
    );
    yield* _fetchAndYieldSettings(settings);
  }

  Stream<SettingsState> _mapSettingsUpdateSecondaryConnectionToState({
    @required Logging logging,
    @required Settings settings,
    @required int id,
    @required String secondaryConnectionAddress,
  }) async* {
    logging.info('Settings: Updating secondary connection address');
    await settings.updateSecondaryConnection(
      id: id,
      secondaryConnectionAddress: secondaryConnectionAddress.trim(),
    );
    yield* _fetchAndYieldSettings(settings);
  }

  Stream<SettingsState> _mapSettingsUpdateDeviceTokenToState({
    @required Logging logging,
    @required Settings settings,
    @required int id,
    @required String deviceToken,
  }) async* {
    logging.info('Settings: Updating device token');
    await settings.updateDeviceToken(
      id: id,
      deviceToken: deviceToken.trim(),
    );
    yield* _fetchAndYieldSettings(settings);
  }

  Stream<SettingsState> _mapSettingsUpdateServerTimeoutToState({
    @required Logging logging,
    @required Settings settings,
    @required int timeout,
  }) async* {
    logging.info('Settings: Updating server timeout to ${timeout}s');
    await settings.setServerTimeout(timeout);
    yield* _fetchAndYieldSettings(settings);
  }

  Stream<SettingsState> _mapSettingsSettingsUpdateRefreshRateToState({
    @required Logging logging,
    @required Settings settings,
    @required int refreshRate,
  }) async* {
    final String refreshRateString =
        refreshRate != null ? '${refreshRate}s' : 'disabled';
    logging.info('Settings: Updating server timeout to $refreshRateString');

    await settings.setRefreshRate(refreshRate);
    yield* _fetchAndYieldSettings(settings);
  }

  Stream<SettingsState> _fetchAndYieldSettings(Settings settings) async* {
    final serverList = await settings.getAllServers();
    final serverTimeout = await settings.getServerTimeout();
    final refreshRate = await settings.getRefreshRate();

    yield SettingsLoadSuccess(
      serverList: serverList,
      serverTimeout: serverTimeout,
      refreshRate: refreshRate,
    );
  }
}
