import '../../../../core/database/data/models/server_model.dart';
import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required ServerModel activeServer,
    required bool doubleBackToExit,
    required bool maskSensitiveInfo,
    required bool oneSignalBannerDismissed,
    required bool oneSignalConsented,
    required int refreshRate,
    required int serverTimeout,
  }) : super(
          activeServer: activeServer,
          doubleBackToExit: doubleBackToExit,
          maskSensitiveInfo: maskSensitiveInfo,
          oneSignalBannerDismissed: oneSignalBannerDismissed,
          oneSignalConsented: oneSignalConsented,
          refreshRate: refreshRate,
          serverTimeout: serverTimeout,
        );

  AppSettingsModel copyWith({
    ServerModel? activeServer,
    bool? doubleBackToExit,
    bool? maskSensitiveInfo,
    bool? oneSignalBannerDismissed,
    bool? oneSignalConsented,
    int? refreshRate,
    int? serverTimeout,
  }) {
    return AppSettingsModel(
      activeServer: activeServer ?? this.activeServer,
      doubleBackToExit: doubleBackToExit ?? this.doubleBackToExit,
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
      'Active Server': activeServer.plexName,
      'Double Back To Exit': doubleBackToExit.toString(),
      'Mask Sensitive Info': maskSensitiveInfo.toString(),
      'OneSignal Banner Dismissed': oneSignalBannerDismissed.toString(),
      'OneSignal Privacy Accepted': oneSignalConsented.toString(),
      'Refresh Rate': refreshRate.toString(),
      'Server Timeout': serverTimeout.toString(),
    };
  }
}
