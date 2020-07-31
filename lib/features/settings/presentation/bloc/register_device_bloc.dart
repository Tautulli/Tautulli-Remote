import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/domain/entities/server.dart';
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
  final ConnectionAddressHelper connectionAddressHelper;
  final Logging logging;

  RegisterDeviceBloc({
    @required this.registerDevice,
    @required this.settings,
    @required this.connectionAddressHelper,
    @required this.logging,
  }) : super(RegisterDeviceInitial());

  @override
  Stream<RegisterDeviceState> mapEventToState(
    RegisterDeviceEvent event,
  ) async* {
    if (event is RegisterDeviceFromQrStarted) {
      //TODO: Change to debug
      logging
          .info('RegisterDevice: Attempting to register device with QR code');
      yield RegisterDeviceInProgress();

      final List result = event.result.split('|');

      yield* _registerDeviceOrFailure(
        result[0].trim(),
        result[1].trim(),
        event.settingsBloc,
      );
    }
    if (event is RegisterDeviceManualStarted) {
      //TODO: Change to debug
      logging.info('RegisterDevice: Attempting to register device manually');
      yield RegisterDeviceInProgress();
      yield* _registerDeviceOrFailure(
        event.connectionAddress.trim(),
        event.deviceToken.trim(),
        event.settingsBloc,
      );
    }
  }

  Stream<RegisterDeviceState> _registerDeviceOrFailure(
    String connectionAddress,
    String deviceToken,
    SettingsBloc settingsBloc,
  ) async* {
    final connectionMap = connectionAddressHelper.parse(connectionAddress);
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
        yield RegisterDeviceFailure();
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
              secondaryConnectionAddress: existingServer.secondaryConnectionAddress,
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
