import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/helpers/connection_address_helper.dart';
import '../../domain/usecases/register_device.dart';
import 'settings_bloc.dart';

part 'register_device_event.dart';
part 'register_device_state.dart';

class RegisterDeviceBloc
    extends Bloc<RegisterDeviceEvent, RegisterDeviceState> {
  final RegisterDevice registerDevice;
  final ConnectionAddressHelper connectionAddressHelper;

  RegisterDeviceBloc({
    @required this.registerDevice,
    @required this.connectionAddressHelper,
  }) : super(RegisterDeviceInitial());

  @override
  Stream<RegisterDeviceState> mapEventToState(
    RegisterDeviceEvent event,
  ) async* {
    if (event is RegisterDeviceFromQrStarted) {
      yield RegisterDeviceInProgress();

      final List result = event.result.split('|');

      yield* _registerDeviceOrFailure(
        result[0],
        result[1],
        event.settingsBloc,
      );
    }
    if (event is RegisterDeviceStarted) {
      yield* _registerDeviceOrFailure(
        event.connectionAddress,
        event.deviceToken,
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
    final connectionUser = connectionMap['user'];
    final connectionPassword = connectionMap['password'];

    final failureOrRegistered = await registerDevice(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionUser: connectionUser,
      connectionPassword: connectionPassword,
      deviceToken: deviceToken,
    );

    yield* failureOrRegistered.fold(
      (failure) async* {
        yield RegisterDeviceFailure();
      },
      (registered) async* {
        settingsBloc.add(SettingsUpdateConnection(value: connectionAddress));
        settingsBloc.add(SettingsUpdateDeviceToken(value: deviceToken));
        yield RegisterDeviceSuccess();
      },
    );
  }
}
