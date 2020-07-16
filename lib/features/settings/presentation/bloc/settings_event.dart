part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsLoad extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsUpdateConnection extends SettingsEvent {
  final String value;

  SettingsUpdateConnection({@required this.value});

  @override
  List<Object> get props => [value];
}

class SettingsUpdateDeviceToken extends SettingsEvent {
  final String value;

  SettingsUpdateDeviceToken({@required this.value});

  @override
  List<Object> get props => [value];
}
