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

  const RegisterDeviceStarted({
    required this.primaryConnectionAddress,
    required this.secondaryConnectionAddress,
    required this.deviceToken,
    required this.headers,
  });

  @override
  List<Object> get props => [
        primaryConnectionAddress,
        secondaryConnectionAddress,
        deviceToken,
        headers,
      ];
}

class RegisterDeviceUnverifiedCert extends RegisterDeviceEvent {}
