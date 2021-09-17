// @dart=2.9

part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsLoad extends SettingsEvent {
  final SettingsBloc settingsBloc;

  SettingsLoad({@required this.settingsBloc});

  @override
  List<Object> get props => [];
}

class SettingsAddServer extends SettingsEvent {
  final String primaryConnectionAddress;
  final String secondaryConnectionAddress;
  final String deviceToken;
  final String tautulliId;
  final String plexName;
  final String plexIdentifier;
  final bool plexPass;
  final bool onesignalRegistered;
  List<CustomHeaderModel> headers;

  SettingsAddServer({
    @required this.primaryConnectionAddress,
    this.secondaryConnectionAddress,
    @required this.deviceToken,
    @required this.tautulliId,
    @required this.plexName,
    @required this.plexIdentifier,
    @required this.plexPass,
    this.onesignalRegistered,
    this.headers,
  });

  @override
  List<Object> get props => [
        primaryConnectionAddress,
        secondaryConnectionAddress,
        deviceToken,
        tautulliId,
        plexName,
        plexPass,
        onesignalRegistered,
        headers,
      ];
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
  final String dateFormat;
  final String timeFormat;
  final bool onesignalRegistered;
  final List<CustomHeaderModel> headers;

  SettingsUpdateServer({
    @required this.id,
    @required this.sortIndex,
    @required this.primaryConnectionAddress,
    @required this.secondaryConnectionAddress,
    @required this.deviceToken,
    @required this.tautulliId,
    @required this.plexName,
    @required this.plexIdentifier,
    @required this.plexPass,
    @required this.dateFormat,
    @required this.timeFormat,
    this.onesignalRegistered,
    this.headers,
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
        dateFormat,
        timeFormat,
        onesignalRegistered,
        headers,
      ];
}

class SettingsUpdatePrimaryConnection extends SettingsEvent {
  final int id;
  final String primaryConnectionAddress;
  final String plexName;

  SettingsUpdatePrimaryConnection({
    @required this.id,
    @required this.primaryConnectionAddress,
    @required this.plexName,
  });

  @override
  List<Object> get props => [id, primaryConnectionAddress, plexName];
}

class SettingsUpdateSecondaryConnection extends SettingsEvent {
  final int id;
  final String secondaryConnectionAddress;
  final String plexName;

  SettingsUpdateSecondaryConnection({
    @required this.id,
    @required this.secondaryConnectionAddress,
    @required this.plexName,
  });

  @override
  List<Object> get props => [id, secondaryConnectionAddress, plexName];
}

class SettingsUpdatePrimaryActive extends SettingsEvent {
  final String tautulliId;
  final bool primaryActive;

  SettingsUpdatePrimaryActive({
    @required this.tautulliId,
    @required this.primaryActive,
  });

  @override
  List<Object> get props => [tautulliId, primaryActive];
}

class SettingsAddCustomHeader extends SettingsEvent {
  final String tautulliId;
  final String key;
  final String value;
  final bool basicAuth;
  final String previousKey;

  SettingsAddCustomHeader({
    @required this.tautulliId,
    @required this.key,
    @required this.value,
    this.basicAuth = false,
    this.previousKey,
  });

  @override
  List<Object> get props => [tautulliId, key, value, basicAuth, previousKey];
}

class SettingsRemoveCustomHeader extends SettingsEvent {
  final String tautulliId;
  final String key;

  SettingsRemoveCustomHeader({
    @required this.tautulliId,
    @required this.key,
  });

  @override
  List<Object> get props => [tautulliId, key];
}

class SettingsUpdateSortIndex extends SettingsEvent {
  final int serverId;
  final int oldIndex;
  final int newIndex;

  SettingsUpdateSortIndex({
    @required this.serverId,
    @required this.oldIndex,
    @required this.newIndex,
  });

  @override
  List<Object> get props => [serverId, oldIndex, newIndex];
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

class SettingsUpdateDoubleTapToExit extends SettingsEvent {
  final bool value;

  SettingsUpdateDoubleTapToExit({@required this.value});

  @override
  List<Object> get props => [value];
}

class SettingsUpdateMaskSensitiveInfo extends SettingsEvent {
  final bool value;

  SettingsUpdateMaskSensitiveInfo({@required this.value});

  @override
  List<Object> get props => [value];
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

class SettingsUpdateYAxis extends SettingsEvent {
  final String yAxis;

  SettingsUpdateYAxis({@required this.yAxis});

  @override
  List<Object> get props => [yAxis];
}

class SettingsUpdateUsersSort extends SettingsEvent {
  final String usersSort;

  SettingsUpdateUsersSort({@required this.usersSort});

  @override
  List<Object> get props => [usersSort];
}

class SettingsUpdateOneSignalBannerDismiss extends SettingsEvent {
  final bool dismiss;

  SettingsUpdateOneSignalBannerDismiss(this.dismiss);

  @override
  List<Object> get props => [dismiss];
}

class SettingsUpdateLastAppVersion extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsUpdateWizardCompleteStatus extends SettingsEvent {
  final bool complete;

  SettingsUpdateWizardCompleteStatus(this.complete);

  @override
  List<Object> get props => [complete];
}

class SettingsUpdateIosLocalNetworkPermissionPrompted extends SettingsEvent {
  final bool prompted;

  SettingsUpdateIosLocalNetworkPermissionPrompted(this.prompted);

  @override
  List<Object> get props => [prompted];
}

class SettingsUpdateGraphTipsShown extends SettingsEvent {
  final bool shown;

  SettingsUpdateGraphTipsShown(this.shown);

  @override
  List<Object> get props => [shown];
}

class SettingsDeleteServer extends SettingsEvent {
  final int id;
  final String plexName;

  SettingsDeleteServer({
    @required this.id,
    @required this.plexName,
  });

  @override
  List<Object> get props => [id, plexName];
}
