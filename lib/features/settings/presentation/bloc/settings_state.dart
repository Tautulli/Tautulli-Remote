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
  final List<ServerModel> serverList;

  SettingsLoadSuccess({
    @required this.serverList,
  });

  @override
  List<Object> get props => [serverList];
}
