import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/types/play_metric_type.dart';

class AppSettingsModel extends Equatable {
  final ServerModel activeServer;
  final bool appUpdateAvailable;
  final bool doubleBackToExit;
  final int graphTimeRange;
  final bool graphTipsShown;
  final PlayMetricType graphYAxis;
  final String librariesSort;
  final bool libraryMediaFullRefresh;
  final bool maskSensitiveInfo;
  final bool multiserverActivity;
  final bool oneSignalBannerDismissed;
  final bool oneSignalConsented;
  final int refreshRate;
  final bool secret;
  final int serverTimeout;
  final PlayMetricType statisticsStatType;
  final int statisticsTimeRange;
  final bool useAtkinsonHyperlegible;
  final String usersSort;
  final bool wizardComplete;

  const AppSettingsModel({
    required this.activeServer,
    required this.appUpdateAvailable,
    required this.doubleBackToExit,
    required this.graphTimeRange,
    required this.graphTipsShown,
    required this.graphYAxis,
    required this.librariesSort,
    required this.libraryMediaFullRefresh,
    required this.maskSensitiveInfo,
    required this.multiserverActivity,
    required this.oneSignalBannerDismissed,
    required this.oneSignalConsented,
    required this.refreshRate,
    required this.secret,
    required this.serverTimeout,
    required this.statisticsStatType,
    required this.statisticsTimeRange,
    required this.useAtkinsonHyperlegible,
    required this.usersSort,
    required this.wizardComplete,
  });

  AppSettingsModel copyWith({
    ServerModel? activeServer,
    bool? appUpdateAvailable,
    bool? doubleBackToExit,
    int? graphTimeRange,
    bool? graphTipsShown,
    PlayMetricType? graphYAxis,
    String? librariesSort,
    bool? libraryMediaFullRefresh,
    bool? maskSensitiveInfo,
    bool? multiserverActivity,
    bool? oneSignalBannerDismissed,
    bool? oneSignalConsented,
    int? refreshRate,
    bool? secret,
    int? serverTimeout,
    PlayMetricType? statisticsStatType,
    int? statisticsTimeRange,
    bool? useAtkinsonHyperlegible,
    String? usersSort,
    bool? wizardComplete,
  }) {
    return AppSettingsModel(
      activeServer: activeServer ?? this.activeServer,
      appUpdateAvailable: appUpdateAvailable ?? this.appUpdateAvailable,
      doubleBackToExit: doubleBackToExit ?? this.doubleBackToExit,
      graphTimeRange: graphTimeRange ?? this.graphTimeRange,
      graphTipsShown: graphTipsShown ?? this.graphTipsShown,
      graphYAxis: graphYAxis ?? this.graphYAxis,
      librariesSort: librariesSort ?? this.librariesSort,
      libraryMediaFullRefresh:
          libraryMediaFullRefresh ?? this.libraryMediaFullRefresh,
      maskSensitiveInfo: maskSensitiveInfo ?? this.maskSensitiveInfo,
      multiserverActivity: multiserverActivity ?? this.multiserverActivity,
      oneSignalBannerDismissed:
          oneSignalBannerDismissed ?? this.oneSignalBannerDismissed,
      oneSignalConsented: oneSignalConsented ?? this.oneSignalConsented,
      refreshRate: refreshRate ?? this.refreshRate,
      secret: secret ?? this.secret,
      serverTimeout: serverTimeout ?? this.serverTimeout,
      statisticsStatType: statisticsStatType ?? this.statisticsStatType,
      statisticsTimeRange: statisticsTimeRange ?? this.statisticsTimeRange,
      useAtkinsonHyperlegible:
          useAtkinsonHyperlegible ?? this.useAtkinsonHyperlegible,
      usersSort: usersSort ?? this.usersSort,
      wizardComplete: wizardComplete ?? this.wizardComplete,
    );
  }

  Map<String, String> dump() {
    return {
      'Active Server': '${activeServer.plexName} (${activeServer.id})',
      'App Update Available': appUpdateAvailable.toString(),
      'Double Back To Exit': doubleBackToExit.toString(),
      'Graph Time Range': graphTimeRange.toString(),
      'Graph Tips Shown': graphTipsShown.toString(),
      'Graph Y Axis': graphYAxis.toString(),
      'Libraries Sort': librariesSort.toString(),
      'Library Media Full Refresh': libraryMediaFullRefresh.toString(),
      'Mask Sensitive Info': maskSensitiveInfo.toString(),
      'Multiserver Activity': multiserverActivity.toString(),
      'OneSignal Banner Dismissed': oneSignalBannerDismissed.toString(),
      'OneSignal Privacy Accepted': oneSignalConsented.toString(),
      'Refresh Rate': refreshRate.toString(),
      'Server Timeout': serverTimeout.toString(),
      'Statistics Stat Type': statisticsStatType.toString(),
      'Statistics Time Range': statisticsTimeRange.toString(),
      'Use Atkinson Hyperlegible Font': useAtkinsonHyperlegible.toString(),
      'Users Sort': usersSort,
      'Wizard Complete': wizardComplete.toString(),
    };
  }

  @override
  List<Object> get props => [
        activeServer,
        appUpdateAvailable,
        doubleBackToExit,
        graphTimeRange,
        graphTipsShown,
        graphYAxis,
        librariesSort,
        libraryMediaFullRefresh,
        maskSensitiveInfo,
        multiserverActivity,
        oneSignalBannerDismissed,
        oneSignalConsented,
        refreshRate,
        secret,
        serverTimeout,
        statisticsStatType,
        statisticsTimeRange,
        useAtkinsonHyperlegible,
        usersSort,
        wizardComplete,
      ];
}
