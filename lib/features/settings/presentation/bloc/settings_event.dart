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
  final bool plexPass;

  SettingsAddServer({
    @required this.primaryConnectionAddress,
    @required this.deviceToken,
    @required this.tautulliId,
    @required this.plexName,
    @required this.plexPass,
  });

  @override
  List<Object> get props => [
        primaryConnectionAddress,
        deviceToken,
        tautulliId,
        plexName,
        plexPass,
      ];
}

class SettingsUpdateServer extends SettingsEvent {
  final int id;
  final String primaryConnectionAddress;
  final String secondaryConnectionAddress;
  final String deviceToken;
  final String tautulliId;
  final String plexName;
  final bool plexPass;
  final String dateFormat;
  final String timeFormat;

  SettingsUpdateServer({
    @required this.id,
    @required this.primaryConnectionAddress,
    @required this.secondaryConnectionAddress,
    @required this.deviceToken,
    @required this.tautulliId,
    @required this.plexName,
    @required this.plexPass,
    @required this.dateFormat,
    @required this.timeFormat,
  });

  @override
  List<Object> get props => [
        id,
        primaryConnectionAddress,
        secondaryConnectionAddress,
        deviceToken,
        tautulliId,
        plexName,
        plexPass,
        dateFormat,
        timeFormat,
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

class SettingsUpdateServerTimeout extends SettingsEvent {
  final int timeout;

  SettingsUpdateServerTimeout({@required this.timeout});

  @override
  List<Object> get props => [timeout];
}

class SettingsUpdateRefreshRate extends SettingsEvent {
  final int refreshRate;

  SettingsUpdateRefreshRate({@required this.refreshRate});

  @override
  List<Object> get props => [refreshRate];
}

class SettingsUpdateLastSelectedServer extends SettingsEvent {
  final String tautulliId;

  SettingsUpdateLastSelectedServer({@required this.tautulliId});

  @override
  List<Object> get props => [tautulliId];
}

class SettingsUpdateStatsType extends SettingsEvent {
  final String statsType;

  SettingsUpdateStatsType({@required this.statsType});

  @override
  List<Object> get props => [statsType];
}

class SettingsDeleteServer extends SettingsEvent {
  final int id;

  SettingsDeleteServer({@required this.id});

  @override
  List<Object> get props => [id];
}
