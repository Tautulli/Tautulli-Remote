part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsInProgress extends SettingsState {}

class SettingsSuccess extends SettingsState {
  final AppSettingsModel appSettings;

  const SettingsSuccess({required this.appSettings});

  @override
  List<Object> get props => [appSettings];
}

class SettingsFailure extends SettingsState {}
