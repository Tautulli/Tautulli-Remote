part of 'register_device_bloc.dart';

abstract class RegisterDeviceState extends Equatable {
  const RegisterDeviceState();

  @override
  List<Object> get props => [];
}

class RegisterDeviceInitial extends RegisterDeviceState {}

class RegisterDeviceInProgress extends RegisterDeviceState {}

class RegisterDeviceSuccess extends RegisterDeviceState {}

class RegisterDeviceFailure extends RegisterDeviceState {
  final Failure failure;

  const RegisterDeviceFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
