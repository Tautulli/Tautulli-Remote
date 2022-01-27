import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required bool doubleTapToExit,
    required bool maskSensitiveInfo,
    required bool oneSignalBannerDismissed,
    required int refreshRate,
    required int serverTimeout,
  }) : super(
          doubleTapToExit: doubleTapToExit,
          maskSensitiveInfo: maskSensitiveInfo,
          oneSignalBannerDismissed: oneSignalBannerDismissed,
          refreshRate: refreshRate,
          serverTimeout: serverTimeout,
        );

  AppSettingsModel copyWith({
    bool? doubleTapToExit,
    bool? maskSensitiveInfo,
    bool? oneSignalBannerDismissed,
    int? refreshRate,
    int? serverTimeout,
  }) {
    return AppSettingsModel(
      doubleTapToExit: doubleTapToExit ?? this.doubleTapToExit,
      maskSensitiveInfo: maskSensitiveInfo ?? this.maskSensitiveInfo,
      oneSignalBannerDismissed:
          oneSignalBannerDismissed ?? this.oneSignalBannerDismissed,
      refreshRate: refreshRate ?? this.refreshRate,
      serverTimeout: serverTimeout ?? this.serverTimeout,
    );
  }
}
