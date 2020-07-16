part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoadInProgress extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoadSuccess extends SettingsState {
  final Settings settings;

  SettingsLoadSuccess({
    @required this.settings,
  });

  @override
  List<Object> get props => [settings];
}
