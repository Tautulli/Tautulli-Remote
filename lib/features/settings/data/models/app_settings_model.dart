import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required bool doubleTapToExit,
    required bool maskSensitiveInfo,
    required int refreshRate,
    required int serverTimeout,
  }) : super(
          doubleTapToExit: doubleTapToExit,
          maskSensitiveInfo: maskSensitiveInfo,
          refreshRate: refreshRate,
          serverTimeout: serverTimeout,
        );

  AppSettingsModel copyWith({
    bool? doubleTapToExit,
    bool? maskSensitiveInfo,
    int? refreshRate,
    int? serverTimeout,
  }) {
    return AppSettingsModel(
      doubleTapToExit: doubleTapToExit ?? this.doubleTapToExit,
      maskSensitiveInfo: maskSensitiveInfo ?? this.maskSensitiveInfo,
      refreshRate: refreshRate ?? this.refreshRate,
      serverTimeout: serverTimeout ?? this.serverTimeout,
    );
  }
}
