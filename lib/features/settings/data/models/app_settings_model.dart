import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required bool doubleTapToExit,
    required bool maskSensitiveInfo,
    required bool oneSignalBannerDismissed,
    required bool oneSignalConsented,
    required int refreshRate,
    required int serverTimeout,
  }) : super(
          doubleTapToExit: doubleTapToExit,
          maskSensitiveInfo: maskSensitiveInfo,
          oneSignalBannerDismissed: oneSignalBannerDismissed,
          oneSignalConsented: oneSignalConsented,
          refreshRate: refreshRate,
          serverTimeout: serverTimeout,
        );

  AppSettingsModel copyWith({
    bool? doubleTapToExit,
    bool? maskSensitiveInfo,
    bool? oneSignalBannerDismissed,
    bool? oneSignalConsented,
    int? refreshRate,
    int? serverTimeout,
  }) {
    return AppSettingsModel(
      doubleTapToExit: doubleTapToExit ?? this.doubleTapToExit,
      maskSensitiveInfo: maskSensitiveInfo ?? this.maskSensitiveInfo,
      oneSignalBannerDismissed:
          oneSignalBannerDismissed ?? this.oneSignalBannerDismissed,
      oneSignalConsented: oneSignalConsented ?? this.oneSignalConsented,
      refreshRate: refreshRate ?? this.refreshRate,
      serverTimeout: serverTimeout ?? this.serverTimeout,
    );
  }

  Map<String, String> dump() {
    return {
      'Double Tap To Exit': doubleTapToExit.toString(),
      'Mask Sensitive Info': maskSensitiveInfo.toString(),
      'OneSignal Banner Dismissed': oneSignalBannerDismissed.toString(),
      'OneSignal Privacy Accepted': oneSignalConsented.toString(),
      'Refresh Rate': refreshRate.toString(),
      'Server Timeout': serverTimeout.toString(),
    };
  }
}
