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
  final int serverTimeout;
  final int refreshRate;
  final String lastSelectedServer;

  SettingsLoadSuccess({
    @required this.serverList,
    @required this.serverTimeout,
    @required this.refreshRate,
    @required this.lastSelectedServer,
  });

  @override
  List<Object> get props => [
        serverList,
        serverTimeout,
        refreshRate,
        lastSelectedServer,
      ];
}
