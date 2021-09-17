// @dart=2.9

part of 'register_device_headers_bloc.dart';

abstract class RegisterDeviceHeadersEvent extends Equatable {
  const RegisterDeviceHeadersEvent();

  @override
  List<Object> get props => [];
}

class RegisterDeviceHeadersAdd extends RegisterDeviceHeadersEvent {
  final String key;
  final String value;
  final bool basicAuth;
  final String previousKey;

  RegisterDeviceHeadersAdd({
    @required this.key,
    @required this.value,
    @required this.basicAuth,
    this.previousKey,
  });

  @override
  List<Object> get props => [key, value, basicAuth, previousKey];
}

class RegisterDeviceHeadersRemove extends RegisterDeviceHeadersEvent {
  final String key;

  RegisterDeviceHeadersRemove(this.key);

  @override
  List<Object> get props => [key];
}

class RegisterDeviceHeadersClear extends RegisterDeviceHeadersEvent {}
