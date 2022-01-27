part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsClearCache extends SettingsEvent {}

class SettingsLoad extends SettingsEvent {}

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

class SettingsUpdateRefreshRate extends SettingsEvent {
  final int refreshRate;

  const SettingsUpdateRefreshRate(this.refreshRate);

  @override
  List<Object> get props => [refreshRate];
}

class SettingsUpdateServerTimeout extends SettingsEvent {
  final int timeout;

  const SettingsUpdateServerTimeout(this.timeout);

  @override
  List<Object> get props => [timeout];
}
