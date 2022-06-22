import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/types/graph_y_axis.dart';

class AppSettingsModel extends Equatable {
  final ServerModel activeServer;
  final bool doubleBackToExit;
  final int graphTimeRange;
  final bool graphTipsShown;
  final GraphYAxis graphYAxis;
  final bool maskSensitiveInfo;
  final bool oneSignalBannerDismissed;
  final bool oneSignalConsented;
  final int refreshRate;
  final bool secret;
  final int serverTimeout;
  final String usersSort;
  final bool wizardComplete;

  const AppSettingsModel({
    required this.activeServer,
    required this.doubleBackToExit,
    required this.graphTimeRange,
    required this.graphTipsShown,
    required this.graphYAxis,
    required this.maskSensitiveInfo,
    required this.oneSignalBannerDismissed,
    required this.oneSignalConsented,
    required this.refreshRate,
    required this.secret,
    required this.serverTimeout,
    required this.usersSort,
    required this.wizardComplete,
  });

  AppSettingsModel copyWith({
    ServerModel? activeServer,
    bool? doubleBackToExit,
    int? graphTimeRange,
    bool? graphTipsShown,
    GraphYAxis? graphYAxis,
    bool? maskSensitiveInfo,
    bool? oneSignalBannerDismissed,
    bool? oneSignalConsented,
    int? refreshRate,
    bool? secret,
    int? serverTimeout,
    String? usersSort,
    bool? wizardComplete,
  }) {
    return AppSettingsModel(
      activeServer: activeServer ?? this.activeServer,
      doubleBackToExit: doubleBackToExit ?? this.doubleBackToExit,
      graphTimeRange: graphTimeRange ?? this.graphTimeRange,
      graphTipsShown: graphTipsShown ?? this.graphTipsShown,
      graphYAxis: graphYAxis ?? this.graphYAxis,
      maskSensitiveInfo: maskSensitiveInfo ?? this.maskSensitiveInfo,
      oneSignalBannerDismissed:
          oneSignalBannerDismissed ?? this.oneSignalBannerDismissed,
      oneSignalConsented: oneSignalConsented ?? this.oneSignalConsented,
      refreshRate: refreshRate ?? this.refreshRate,
      secret: secret ?? this.secret,
      serverTimeout: serverTimeout ?? this.serverTimeout,
      usersSort: usersSort ?? this.usersSort,
      wizardComplete: wizardComplete ?? this.wizardComplete,
    );
  }

  Map<String, String> dump() {
    return {
      'Active Server': '${activeServer.plexName} (${activeServer.id})',
      'Double Back To Exit': doubleBackToExit.toString(),
      'Graph Time Range': graphTimeRange.toString(),
      'Graph Tips Shown': graphTipsShown.toString(),
      'Graph Y Axis': graphYAxis.toString(),
      'Mask Sensitive Info': maskSensitiveInfo.toString(),
      'OneSignal Banner Dismissed': oneSignalBannerDismissed.toString(),
      'OneSignal Privacy Accepted': oneSignalConsented.toString(),
      'Refresh Rate': refreshRate.toString(),
      'Server Timeout': serverTimeout.toString(),
      'Users Sort': usersSort,
      'Wizard Complete': wizardComplete.toString(),
    };
  }

  @override
  List<Object> get props => [
        activeServer,
        doubleBackToExit,
        graphTimeRange,
        graphTipsShown,
        graphYAxis,
        maskSensitiveInfo,
        oneSignalBannerDismissed,
        oneSignalConsented,
        refreshRate,
        secret,
        serverTimeout,
        usersSort,
        wizardComplete,
      ];
}
