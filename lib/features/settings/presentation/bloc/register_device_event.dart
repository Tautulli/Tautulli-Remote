part of 'register_device_bloc.dart';

abstract class RegisterDeviceEvent extends Equatable {
  const RegisterDeviceEvent();
}

class RegisterDeviceStarted extends RegisterDeviceEvent {
  final String result;
  final SettingsBloc settingsBloc;

  RegisterDeviceStarted({@required this.result, @required this.settingsBloc});

  @override
  List<Object> get props => [result];
}
