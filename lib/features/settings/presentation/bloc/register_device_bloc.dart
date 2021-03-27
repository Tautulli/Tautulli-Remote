import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:validators/validators.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/connection_address_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/usecases/register_device.dart';
import '../../domain/usecases/settings.dart';
import 'settings_bloc.dart';

part 'register_device_event.dart';
part 'register_device_state.dart';

String connectionAddressCache;
String deviceTokenCache;

class RegisterDeviceBloc
    extends Bloc<RegisterDeviceEvent, RegisterDeviceState> {
  final RegisterDevice registerDevice;
  final Settings settings;
  final Logging logging;

  RegisterDeviceBloc({
    @required this.registerDevice,
    @required this.settings,
    @required this.logging,
  }) : super(RegisterDeviceInitial());

  @override
  Stream<RegisterDeviceState> mapEventToState(
    RegisterDeviceEvent event,
  ) async* {
    if (event is RegisterDeviceFromQrStarted) {
      yield* _mapRegisterDeviceFromQrStartedToState(
        event.result,
        event.settingsBloc,
      );
    }
    if (event is RegisterDeviceManualStarted) {
      yield* _mapRegisterDeviceManualStartedToState(
        connectionAddress: event.connectionAddress,
        deviceToken: event.deviceToken,
        settingsBloc: event.settingsBloc,
      );
    }
    if (event is RegisterDeviceUnverifiedCert) {
      yield RegisterDeviceInProgress();

      yield* _failureOrRegisterDevice(
        connectionAddressCache,
        deviceTokenCache,
        event.settingsBloc,
        trustCert: true,
      );
    }
  }

  Stream<RegisterDeviceState> _mapRegisterDeviceFromQrStartedToState(
    String result,
    SettingsBloc settingsBloc,
  ) async* {
    yield RegisterDeviceInProgress();

    try {
      final List resultParts = result.split('|');

      connectionAddressCache = resultParts[0].trim();
      deviceTokenCache = resultParts[1].trim();

      if (!isURL(connectionAddressCache) || deviceTokenCache.length != 32) {
        yield RegisterDeviceFailure(failure: QRScanFailure());
      } else {
        yield* _failureOrRegisterDevice(
          connectionAddressCache,
          deviceTokenCache,
          settingsBloc,
        );
      }
    } catch (_) {
      yield RegisterDeviceFailure(failure: QRScanFailure());
    }
  }

  Stream<RegisterDeviceState> _mapRegisterDeviceManualStartedToState({
    @required String connectionAddress,
    @required String deviceToken,
    @required SettingsBloc settingsBloc,
  }) async* {
    yield RegisterDeviceInProgress();

    connectionAddressCache = connectionAddress.trim();
    deviceTokenCache = deviceToken.trim();

    yield* _failureOrRegisterDevice(
      connectionAddressCache,
      deviceTokenCache,
      settingsBloc,
    );
  }

  Stream<RegisterDeviceState> _failureOrRegisterDevice(
    String connectionAddress,
    String deviceToken,
    SettingsBloc settingsBloc, {
    bool trustCert = false,
  }) async* {
    final connectionMap = ConnectionAddressHelper.parse(connectionAddress);
    final connectionProtocol = connectionMap['protocol'];
    final connectionDomain = connectionMap['domain'];
    final connectionPath = connectionMap['path'];

    final failureOrRegistered = await registerDevice(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
      trustCert: trustCert,
    );

    yield* failureOrRegistered.fold(
      (failure) async* {
        logging.error(
          'RegisterDevice: Failed to register device [$failure]',
        );

        yield RegisterDeviceFailure(failure: failure);
      },
      (registeredData) async* {
        final Server existingServer =
            await settings.getServerByTautulliId(registeredData['server_id']);

        bool plexPass;
        switch (registeredData['pms_plexpass']) {
          case (0):
            plexPass = false;
            break;
          case (1):
            plexPass = true;
            break;
        }

        if (existingServer == null) {
          settingsBloc.add(
            SettingsAddServer(
              primaryConnectionAddress: connectionAddress,
              deviceToken: deviceToken,
              tautulliId: registeredData['server_id'],
              plexName: registeredData['pms_name'],
              plexIdentifier: registeredData['pms_identifier'],
              plexPass: plexPass,
            ),
          );

          logging.info(
            'RegisterDevice: Successfully registered ${registeredData['pms_name']}',
          );

          yield RegisterDeviceSuccess();
        } else {
          settingsBloc.add(
            SettingsUpdateServer(
              id: existingServer.id,
              sortIndex: existingServer.sortIndex,
              primaryConnectionAddress: connectionAddress,
              secondaryConnectionAddress:
                  existingServer.secondaryConnectionAddress,
              deviceToken: deviceToken,
              tautulliId: registeredData['server_id'],
              plexName: registeredData['pms_name'],
              plexIdentifier: registeredData['pms_identifier'],
              plexPass: plexPass,
              dateFormat: existingServer.dateFormat,
              timeFormat: existingServer.timeFormat,
            ),
          );

          logging.info(
            'RegisterDevice: Successfully updated information for ${registeredData['pms_name']}',
          );

          yield RegisterDeviceSuccess();
        }
      },
    );
  }
}
