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
      //TODO: Change to debug
      logging.info('Settings: Loading settings');
      yield SettingsLoadInProgress();
      yield* _fetchAndYieldServerList(settings);
    }
    if (event is SettingsAddServer) {
      logging.info('Settings: Adding server');
      await settings.addServer(
        primaryConnectionAddress: event.primaryConnectionAddress,
        deviceToken: event.deviceToken,
        tautulliId: event.tautulliId,
        plexName: event.plexName,
      );
      yield* _fetchAndYieldServerList(settings);
    }
    if (event is SettingsUpdateServer) {
      logging.info('Settings: Updating server');
      await settings.updateServerById(
        id: event.id,
        primaryConnectionAddress: event.primaryConnectionAddress,
        deviceToken: event.deviceToken,
        tautulliId: event.tautulliId,
        plexName: event.plexName,
      );
      yield* _fetchAndYieldServerList(settings);
    }
    if (event is SettingsDeleteServer) {
      logging.info('Settings: Deleting server');
      await settings.deleteServer(event.id);
      yield* _fetchAndYieldServerList(settings);
    }
    if (event is SettingsUpdatePrimaryConnection) {
      logging.info('Settings: Updating primary connection address');
      await settings.updatePrimaryConnection(
        id: event.id,
        primaryConnectionAddress: event.primaryConnectionAddress.trim(),
      );
      yield* _fetchAndYieldServerList(settings);
    }
    if (event is SettingsUpdateSecondaryConnection) {
      logging.info('Settings: Updating secondary connection address');
      await settings.updateSecondaryConnection(
        id: event.id,
        secondaryConnectionAddress: event.secondaryConnectionAddress.trim(),
      );
      yield* _fetchAndYieldServerList(settings);
    }
    if (event is SettingsUpdateDeviceToken) {
      logging.info('Settings: Updating device token');
      await settings.updateDeviceToken(
        id: event.id,
        deviceToken: event.deviceToken.trim(),
      );
      yield* _fetchAndYieldServerList(settings);
    }
  }
}

Stream<SettingsState> _fetchAndYieldServerList(Settings settings) async* {
  final serverList = await settings.getAllServers();
  yield SettingsLoadSuccess(serverList: serverList);
}
