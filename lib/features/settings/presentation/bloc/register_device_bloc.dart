import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tautulli_remote_tdd/core/helpers/connection_address_helper.dart';

import '../../../../core/device_info/device_info.dart';
import '../../../onesignal/data/datasources/onesignal_data_source.dart';
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
    if (event is RegisterDeviceStarted) {
      yield RegisterDeviceInProgress();

      final List result = event.result.split('|');

      final connectionAddress = result[0];
      final connectionMap = connectionAddressHelper.parse(connectionAddress);

      final connectionProtocol = connectionMap['protocol'];
      final connectionDomain = connectionMap['domain'];
      final connectionUser = connectionMap['user'];
      final connectionPassword = connectionMap['password'];
      final deviceToken = result[1];

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
          event.settingsBloc
              .add(SettingsUpdateConnection(value: connectionAddress));
          event.settingsBloc.add(SettingsUpdateDeviceToken(value: deviceToken));
          yield RegisterDeviceSuccess();
        },
      );
    }
  }
}
