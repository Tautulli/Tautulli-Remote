part of 'register_device_bloc.dart';

abstract class RegisterDeviceState extends Equatable {
  const RegisterDeviceState();
}

class RegisterDeviceInitial extends RegisterDeviceState {
  @override
  List<Object> get props => [];
}

class RegisterDeviceInProgress extends RegisterDeviceState {
  @override
  List<Object> get props => [];
}

class RegisterDeviceSuccess extends RegisterDeviceState {
  @override
  List<Object> get props => [];
}

class RegisterDeviceFailure extends RegisterDeviceState {
  @override
  List<Object> get props => [];
}