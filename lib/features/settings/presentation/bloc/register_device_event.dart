part of 'register_device_bloc.dart';

abstract class RegisterDeviceEvent extends Equatable {
  const RegisterDeviceEvent();

  @override
  List<Object> get props => [];
}

class RegisterDeviceStarted extends RegisterDeviceEvent {
  final String primaryConnectionAddress;
  final String secondaryConnectionAddress;
  final String deviceToken;
  final List<CustomHeaderModel> headers;
  final SettingsBloc settingsBloc;

  const RegisterDeviceStarted({
    required this.primaryConnectionAddress,
    required this.secondaryConnectionAddress,
    required this.deviceToken,
    required this.headers,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [
        primaryConnectionAddress,
        secondaryConnectionAddress,
        deviceToken,
        headers,
        settingsBloc,
      ];
}

class RegisterDeviceUnverifiedCert extends RegisterDeviceEvent {
  final SettingsBloc settingsBloc;

  const RegisterDeviceUnverifiedCert(this.settingsBloc);

  @override
  List<Object> get props => [settingsBloc];
}
