part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsInProgress extends SettingsState {}

class SettingsSuccess extends SettingsState {
  final List<ServerModel> serverList;
  final AppSettingsModel appSettings;

  const SettingsSuccess({
    required this.serverList,
    required this.appSettings,
  });

  SettingsSuccess copyWith({
    final List<ServerModel>? serverList,
    final AppSettingsModel? appSettings,
  }) {
    return SettingsSuccess(
      serverList: serverList ?? this.serverList,
      appSettings: appSettings ?? this.appSettings,
    );
  }

  @override
  List<Object> get props => [serverList, appSettings];
}

class SettingsFailure extends SettingsState {}
