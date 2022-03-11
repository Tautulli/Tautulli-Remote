import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';

class AppSettingsModel extends Equatable {
  final ServerModel activeServer;
  final bool doubleBackToExit;
  final bool maskSensitiveInfo;
  final bool oneSignalBannerDismissed;
  final bool oneSignalConsented;
  final int refreshRate;
  final int serverTimeout;

  const AppSettingsModel({
    required this.activeServer,
    required this.doubleBackToExit,
    required this.maskSensitiveInfo,
    required this.oneSignalBannerDismissed,
    required this.oneSignalConsented,
    required this.refreshRate,
    required this.serverTimeout,
  });

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
      'Active Server': '${activeServer.plexName} (${activeServer.id})',
      'Double Back To Exit': doubleBackToExit.toString(),
      'Mask Sensitive Info': maskSensitiveInfo.toString(),
      'OneSignal Banner Dismissed': oneSignalBannerDismissed.toString(),
      'OneSignal Privacy Accepted': oneSignalConsented.toString(),
      'Refresh Rate': refreshRate.toString(),
      'Server Timeout': serverTimeout.toString(),
    };
  }

  @override
  List<Object> get props => [
        activeServer,
        doubleBackToExit,
        maskSensitiveInfo,
        oneSignalBannerDismissed,
        oneSignalConsented,
        refreshRate,
        serverTimeout,
      ];
}
