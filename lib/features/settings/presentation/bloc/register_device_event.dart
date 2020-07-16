part of 'register_device_bloc.dart';

abstract class RegisterDeviceEvent extends Equatable {
  const RegisterDeviceEvent();
}

class RegisterDeviceFromQrStarted extends RegisterDeviceEvent {
  final String result;
  final SettingsBloc settingsBloc;

  RegisterDeviceFromQrStarted({
    @required this.result,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [result];
}

class RegisterDeviceStarted extends RegisterDeviceEvent {
  final String connectionAddress;
  final String deviceToken;
  final SettingsBloc settingsBloc;

  RegisterDeviceStarted({
    @required this.connectionAddress,
    @required this.deviceToken,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [connectionAddress, deviceToken];
}
