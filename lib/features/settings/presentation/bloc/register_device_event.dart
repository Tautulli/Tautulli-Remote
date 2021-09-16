// @dart=2.9

part of 'register_device_bloc.dart';

abstract class RegisterDeviceEvent extends Equatable {
  const RegisterDeviceEvent();
}

class RegisterDeviceStarted extends RegisterDeviceEvent {
  final String primaryConnectionAddress;
  final String secondaryConnectionAddress;
  final String deviceToken;
  final List<CustomHeaderModel> headers;
  final SettingsBloc settingsBloc;

  RegisterDeviceStarted({
    @required this.primaryConnectionAddress,
    this.secondaryConnectionAddress,
    @required this.deviceToken,
    this.headers = const [],
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [
        primaryConnectionAddress,
        secondaryConnectionAddress,
        deviceToken,
        headers,
      ];
}

class RegisterDeviceUnverifiedCert extends RegisterDeviceEvent {
  final SettingsBloc settingsBloc;

  RegisterDeviceUnverifiedCert({
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [];
}
