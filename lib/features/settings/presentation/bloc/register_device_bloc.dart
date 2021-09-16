// @dart=2.9

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/connection_address_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../onesignal/data/datasources/onesignal_data_source.dart';
import '../../domain/usecases/register_device.dart';
import '../../domain/usecases/settings.dart';
import 'settings_bloc.dart';

part 'register_device_event.dart';
part 'register_device_state.dart';

String primaryConnectionAddressCache;
String secondaryConnectionAddressCache;
String deviceTokenCache;
List<CustomHeaderModel> headersCache = [];

class RegisterDeviceBloc
    extends Bloc<RegisterDeviceEvent, RegisterDeviceState> {
  final RegisterDevice registerDevice;
  final Settings settings;
  final OneSignalDataSource onesignal;
  final Logging logging;

  RegisterDeviceBloc({
    @required this.registerDevice,
    @required this.settings,
    @required this.onesignal,
    @required this.logging,
  }) : super(RegisterDeviceInitial());

  @override
  Stream<RegisterDeviceState> mapEventToState(
    RegisterDeviceEvent event,
  ) async* {
    if (event is RegisterDeviceStarted) {
      yield* _mapRegisterDeviceStartedToState(
        primaryConnectionAddress: event.primaryConnectionAddress,
        secondaryConnectionAddress: event.secondaryConnectionAddress,
        deviceToken: event.deviceToken,
        headers: event.headers,
        settingsBloc: event.settingsBloc,
      );
    }
    if (event is RegisterDeviceUnverifiedCert) {
      yield RegisterDeviceInProgress();

      yield* _failureOrRegisterDevice(
        primaryConnectionAddressCache,
        secondaryConnectionAddressCache,
        deviceTokenCache,
        event.settingsBloc,
        headers: headersCache,
        trustCert: true,
      );
    }
  }

  Stream<RegisterDeviceState> _mapRegisterDeviceStartedToState({
    @required String primaryConnectionAddress,
    String secondaryConnectionAddress,
    @required String deviceToken,
    List<CustomHeaderModel> headers,
    @required SettingsBloc settingsBloc,
  }) async* {
    yield RegisterDeviceInProgress();

    primaryConnectionAddressCache = primaryConnectionAddress.trim();
    secondaryConnectionAddressCache = secondaryConnectionAddress != null
        ? secondaryConnectionAddress.trim()
        : '';
    deviceTokenCache = deviceToken.trim();
    headersCache = headers;

    yield* _failureOrRegisterDevice(
      primaryConnectionAddressCache,
      secondaryConnectionAddressCache,
      deviceTokenCache,
      settingsBloc,
      headers: headersCache,
    );
  }

  Stream<RegisterDeviceState> _failureOrRegisterDevice(
    String primaryConnectionAddress,
    String secondaryConnectionAddress,
    String deviceToken,
    SettingsBloc settingsBloc, {
    List<CustomHeaderModel> headers,
    bool trustCert = false,
  }) async* {
    final primaryConnectionMap =
        ConnectionAddressHelper.parse(primaryConnectionAddress);
    final primaryConnectionProtocol = primaryConnectionMap['protocol'];
    final primaryConnectionDomain = primaryConnectionMap['domain'];
    final primaryConnectionPath = primaryConnectionMap['path'];

    final onesignalRegistered = isNotEmpty(await onesignal.userId);

    final failureOrRegistered = await registerDevice(
      connectionProtocol: primaryConnectionProtocol,
      connectionDomain: primaryConnectionDomain,
      connectionPath: primaryConnectionPath,
      deviceToken: deviceToken,
      headers: headers,
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
              primaryConnectionAddress: primaryConnectionAddress,
              secondaryConnectionAddress: secondaryConnectionAddress,
              deviceToken: deviceToken,
              tautulliId: registeredData['server_id'],
              plexName: registeredData['pms_name'],
              plexIdentifier: registeredData['pms_identifier'],
              plexPass: plexPass,
              onesignalRegistered: onesignalRegistered,
              headers: headers,
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
              primaryConnectionAddress: primaryConnectionAddress,
              secondaryConnectionAddress:
                  existingServer.secondaryConnectionAddress,
              deviceToken: deviceToken,
              tautulliId: registeredData['server_id'],
              plexName: registeredData['pms_name'],
              plexIdentifier: registeredData['pms_identifier'],
              plexPass: plexPass,
              dateFormat: existingServer.dateFormat,
              timeFormat: existingServer.timeFormat,
              onesignalRegistered: onesignalRegistered,
              headers: headers,
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
