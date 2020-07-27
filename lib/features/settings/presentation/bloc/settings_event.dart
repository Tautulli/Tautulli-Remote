part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsLoad extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsAddServer extends SettingsEvent {
  final String primaryConnectionAddress;
  final String deviceToken;
  final String tautulliId;
  final String plexName;

  SettingsAddServer({
    @required this.primaryConnectionAddress,
    @required this.deviceToken,
    @required this.tautulliId,
    @required this.plexName,
  });

  @override
  List<Object> get props =>
      [primaryConnectionAddress, deviceToken, tautulliId, plexName];
}

class SettingsUpdateServer extends SettingsEvent {
  final int id;
  final String primaryConnectionAddress;
  final String secondaryConnectionAddress;
  final String deviceToken;
  final String tautulliId;
  final String plexName;

  SettingsUpdateServer({
    @required this.id,
    @required this.primaryConnectionAddress,
    @required this.secondaryConnectionAddress,
    @required this.deviceToken,
    @required this.tautulliId,
    @required this.plexName,
  });

  @override
  List<Object> get props => [
        id,
        primaryConnectionAddress,
        secondaryConnectionAddress,
        deviceToken,
        tautulliId,
        plexName,
      ];
}

class SettingsUpdatePrimaryConnection extends SettingsEvent {
  final int id;
  final String primaryConnectionAddress;

  SettingsUpdatePrimaryConnection({
    @required this.id,
    @required this.primaryConnectionAddress,
  });

  @override
  List<Object> get props => [id, primaryConnectionAddress];
}

class SettingsUpdateSecondaryConnection extends SettingsEvent {
  final int id;
  final String secondaryConnectionAddress;

  SettingsUpdateSecondaryConnection({
    @required this.id,
    @required this.secondaryConnectionAddress,
  });

  @override
  List<Object> get props => [id, secondaryConnectionAddress];
}

class SettingsUpdateDeviceToken extends SettingsEvent {
  final int id;
  final String deviceToken;

  SettingsUpdateDeviceToken({
    @required this.id,
    @required this.deviceToken,
  });

  @override
  List<Object> get props => [id, deviceToken];
}

class SettingsDeleteServer extends SettingsEvent {
  final int id;

  SettingsDeleteServer({@required this.id});

  @override
  List<Object> get props => [id];
}
