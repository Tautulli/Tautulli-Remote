part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsAddServer extends SettingsEvent {
  final String primaryConnectionAddress;
  final String? secondaryConnectionAddress;
  final String deviceToken;
  final String tautulliId;
  final String plexName;
  final String plexIdentifier;
  final bool plexPass;
  final bool oneSignalRegistered;
  final List<CustomHeaderModel>? customHeaders;

  const SettingsAddServer({
    required this.primaryConnectionAddress,
    this.secondaryConnectionAddress,
    required this.deviceToken,
    required this.tautulliId,
    required this.plexName,
    required this.plexIdentifier,
    required this.plexPass,
    required this.oneSignalRegistered,
    this.customHeaders,
  });

  @override
  List<Object> get props => [
        primaryConnectionAddress,
        deviceToken,
        tautulliId,
        plexName,
        plexPass,
        oneSignalRegistered,
      ];
}

class SettingsClearCache extends SettingsEvent {}

class SettingsDeleteCustomHeader extends SettingsEvent {
  final String tautulliId;
  final String title;

  const SettingsDeleteCustomHeader({
    required this.tautulliId,
    required this.title,
  });

  @override
  List<Object> get props => [tautulliId, title];
}

class SettingsLoad extends SettingsEvent {}

class SettingsUpdateConnectionInfo extends SettingsEvent {
  final bool primary;
  final String connectionAddress;
  final ServerModel server;

  const SettingsUpdateConnectionInfo({
    required this.primary,
    required this.connectionAddress,
    required this.server,
  });

  @override
  List<Object> get props => [primary, connectionAddress, server];
}

class SettingsUpdateCustomHeaders extends SettingsEvent {
  final String tautulliId;
  final String title;
  final String subtitle;
  final bool basicAuth;
  final String? previousTitle;

  const SettingsUpdateCustomHeaders({
    required this.tautulliId,
    required this.title,
    required this.subtitle,
    required this.basicAuth,
    this.previousTitle,
  });

  @override
  List<Object> get props => [tautulliId, title, subtitle, basicAuth];
}

class SettingsUpdateDoubleTapToExit extends SettingsEvent {
  final bool doubleTapToExit;

  const SettingsUpdateDoubleTapToExit(this.doubleTapToExit);

  @override
  List<Object> get props => [doubleTapToExit];
}

class SettingsUpdateMaskSensitiveInfo extends SettingsEvent {
  final bool maskSensitiveInfo;

  const SettingsUpdateMaskSensitiveInfo(this.maskSensitiveInfo);

  @override
  List<Object> get props => [maskSensitiveInfo];
}

class SettingsUpdateOneSignalBannerDismiss extends SettingsEvent {
  final bool dismiss;

  const SettingsUpdateOneSignalBannerDismiss(this.dismiss);

  @override
  List<Object> get props => [dismiss];
}

class SettingsUpdatePrimaryActive extends SettingsEvent {
  final String tautulliId;
  final bool primaryActive;

  const SettingsUpdatePrimaryActive({
    required this.tautulliId,
    required this.primaryActive,
  });

  @override
  List<Object> get props => [tautulliId, primaryActive];
}

class SettingsUpdateRefreshRate extends SettingsEvent {
  final int refreshRate;

  const SettingsUpdateRefreshRate(this.refreshRate);

  @override
  List<Object> get props => [refreshRate];
}

class SettingsUpdateServer extends SettingsEvent {
  final int id;
  final int sortIndex;
  final String primaryConnectionAddress;
  final String secondaryConnectionAddress;
  final String deviceToken;
  final String tautulliId;
  final String plexName;
  final String plexIdentifier;
  final bool plexPass;
  final String? dateFormat;
  final String? timeFormat;
  final bool oneSignalRegistered;
  final List<CustomHeaderModel>? customHeaders;

  const SettingsUpdateServer({
    required this.id,
    required this.sortIndex,
    required this.primaryConnectionAddress,
    required this.secondaryConnectionAddress,
    required this.deviceToken,
    required this.tautulliId,
    required this.plexName,
    required this.plexIdentifier,
    required this.plexPass,
    this.dateFormat,
    this.timeFormat,
    required this.oneSignalRegistered,
    this.customHeaders,
  });

  @override
  List<Object> get props => [
        id,
        sortIndex,
        primaryConnectionAddress,
        secondaryConnectionAddress,
        deviceToken,
        tautulliId,
        plexName,
        plexPass,
        oneSignalRegistered,
      ];
}

class SettingsUpdateServerSort extends SettingsEvent {
  final int serverId;
  final int oldIndex;
  final int newIndex;

  const SettingsUpdateServerSort({
    required this.serverId,
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object> get props => [serverId, oldIndex, newIndex];
}

class SettingsUpdateServerTimeout extends SettingsEvent {
  final int timeout;

  const SettingsUpdateServerTimeout(this.timeout);

  @override
  List<Object> get props => [timeout];
}
