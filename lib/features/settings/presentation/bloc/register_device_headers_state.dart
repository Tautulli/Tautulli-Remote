// @dart=2.9

part of 'register_device_headers_bloc.dart';

abstract class RegisterDeviceHeadersState extends Equatable {
  const RegisterDeviceHeadersState();

  @override
  List<Object> get props => [];
}

class RegisterDeviceHeadersInitial extends RegisterDeviceHeadersState {}

class RegisterDeviceHeadersLoaded extends RegisterDeviceHeadersState {
  final List<CustomHeaderModel> headers;

  RegisterDeviceHeadersLoaded(this.headers);

  @override
  List<Object> get props => [headers];
}
