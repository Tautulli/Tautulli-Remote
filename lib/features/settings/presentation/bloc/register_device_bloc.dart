import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/connection_address_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/usecases/register_device.dart';
import '../../domain/usecases/settings.dart';
import 'settings_bloc.dart';

part 'register_device_event.dart';
part 'register_device_state.dart';

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
  }

  Stream<RegisterDeviceState> _mapRegisterDeviceFromQrStartedToState(
    String result,
    SettingsBloc settingsBloc,
  ) async* {
    yield RegisterDeviceInProgress();

    final List resultParts = result.split('|');

    yield* _registerDeviceOrFailure(
      resultParts[0].trim(),
      resultParts[1].trim(),
      settingsBloc,
    );
  }

  Stream<RegisterDeviceState> _mapRegisterDeviceManualStartedToState({
    @required String connectionAddress,
    @required String deviceToken,
    @required SettingsBloc settingsBloc,
  }) async* {
    yield RegisterDeviceInProgress();
    yield* _registerDeviceOrFailure(
      connectionAddress.trim(),
      deviceToken.trim(),
      settingsBloc,
    );
  }

  Stream<RegisterDeviceState> _registerDeviceOrFailure(
    String connectionAddress,
    String deviceToken,
    SettingsBloc settingsBloc,
  ) async* {
    final connectionMap = ConnectionAddressHelper.parse(connectionAddress);
    final connectionProtocol = connectionMap['protocol'];
    final connectionDomain = connectionMap['domain'];
    final connectionPath = connectionMap['path'];

    final failureOrRegistered = await registerDevice(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
    );

    yield* failureOrRegistered.fold(
      (failure) async* {
        logging.error('RegisterDevice: Failed to register device [$failure]');
        yield RegisterDeviceFailure(failure: failure);
      },
      (registeredData) async* {
        final Server existingServer =
            await settings.getServerByTautulliId(registeredData['server_id']);

        if (existingServer == null) {
          settingsBloc.add(
            SettingsAddServer(
              primaryConnectionAddress: connectionAddress,
              deviceToken: deviceToken,
              tautulliId: registeredData['server_id'],
              plexName: registeredData['pms_name'],
            ),
          );
          logging
              .info('RegisterDevice: Successfully registered to a new server');
          yield RegisterDeviceSuccess();
        } else {
          settingsBloc.add(
            SettingsUpdateServer(
              id: existingServer.id,
              primaryConnectionAddress: connectionAddress,
              secondaryConnectionAddress:
                  existingServer.secondaryConnectionAddress,
              deviceToken: deviceToken,
              tautulliId: registeredData['server_id'],
              plexName: registeredData['pms_name'],
            ),
          );
          logging
              .info('RegisterDevice: Successfully updated server information');
          yield RegisterDeviceSuccess();
        }
      },
    );
  }
}
