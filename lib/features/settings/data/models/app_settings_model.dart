import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../../../core/types/theme_enhancement_type.dart';
import '../../../../core/types/theme_type.dart';

class AppSettingsModel extends Equatable {
  final ServerModel activeServer;
  final bool appUpdateAvailable;
  final bool disableImageBackgrounds;
  final bool doubleBackToExit;
  final int graphTimeRange;
  final bool graphTipsShown;
  final PlayMetricType graphYAxis;
  final Map<String, bool> historyFilter;
  final String homePage;
  final String librariesSort;
  final bool libraryMediaFullRefresh;
  final bool maskSensitiveInfo;
  final bool multiserverActivity;
  final bool oneSignalBannerDismissed;
  final bool oneSignalConsented;
  final String recentlyAddedFilter;
  final int? patch;
  final int refreshRate;
  final bool secret;
  final int serverTimeout;
  final PlayMetricType statisticsStatType;
  final int statisticsTimeRange;
  final ThemeType theme;
  final Color themeCustomColor;
  final ThemeEnhancementType themeEnhancement;
  final bool themeUseSystemColor;
  final bool useAtkinsonHyperlegible;
  final String usersSort;
  final bool wizardComplete;

  const AppSettingsModel({
    required this.activeServer,
    required this.appUpdateAvailable,
    required this.disableImageBackgrounds,
    required this.doubleBackToExit,
    required this.graphTimeRange,
    required this.graphTipsShown,
    required this.graphYAxis,
    required this.historyFilter,
    required this.homePage,
    required this.librariesSort,
    required this.libraryMediaFullRefresh,
    required this.maskSensitiveInfo,
    required this.multiserverActivity,
    required this.oneSignalBannerDismissed,
    required this.oneSignalConsented,
    required this.patch,
    required this.recentlyAddedFilter,
    required this.refreshRate,
    required this.secret,
    required this.serverTimeout,
    required this.statisticsStatType,
    required this.statisticsTimeRange,
    required this.theme,
    required this.themeCustomColor,
    required this.themeEnhancement,
    required this.themeUseSystemColor,
    required this.useAtkinsonHyperlegible,
    required this.usersSort,
    required this.wizardComplete,
  });

  AppSettingsModel copyWith({
    ServerModel? activeServer,
    bool? appUpdateAvailable,
    bool? disableImageBackgrounds,
    bool? doubleBackToExit,
    int? graphTimeRange,
    bool? graphTipsShown,
    PlayMetricType? graphYAxis,
    Map<String, bool>? historyFilter,
    String? homePage,
    String? librariesSort,
    bool? libraryMediaFullRefresh,
    bool? maskSensitiveInfo,
    bool? multiserverActivity,
    bool? oneSignalBannerDismissed,
    bool? oneSignalConsented,
    int? patch,
    String? recentlyAddedFilter,
    int? refreshRate,
    bool? secret,
    int? serverTimeout,
    PlayMetricType? statisticsStatType,
    int? statisticsTimeRange,
    ThemeType? theme,
    Color? themeCustomColor,
    ThemeEnhancementType? themeEnhancement,
    bool? themeUseSystemColor,
    bool? useAtkinsonHyperlegible,
    String? usersSort,
    bool? wizardComplete,
  }) {
    return AppSettingsModel(
      activeServer: activeServer ?? this.activeServer,
      appUpdateAvailable: appUpdateAvailable ?? this.appUpdateAvailable,
      disableImageBackgrounds: disableImageBackgrounds ?? this.disableImageBackgrounds,
      doubleBackToExit: doubleBackToExit ?? this.doubleBackToExit,
      graphTimeRange: graphTimeRange ?? this.graphTimeRange,
      graphTipsShown: graphTipsShown ?? this.graphTipsShown,
      graphYAxis: graphYAxis ?? this.graphYAxis,
      historyFilter: historyFilter ?? this.historyFilter,
      homePage: homePage ?? this.homePage,
      librariesSort: librariesSort ?? this.librariesSort,
      libraryMediaFullRefresh: libraryMediaFullRefresh ?? this.libraryMediaFullRefresh,
      maskSensitiveInfo: maskSensitiveInfo ?? this.maskSensitiveInfo,
      multiserverActivity: multiserverActivity ?? this.multiserverActivity,
      oneSignalBannerDismissed: oneSignalBannerDismissed ?? this.oneSignalBannerDismissed,
      oneSignalConsented: oneSignalConsented ?? this.oneSignalConsented,
      patch: patch ?? this.patch,
      recentlyAddedFilter: recentlyAddedFilter ?? this.recentlyAddedFilter,
      refreshRate: refreshRate ?? this.refreshRate,
      secret: secret ?? this.secret,
      serverTimeout: serverTimeout ?? this.serverTimeout,
      statisticsStatType: statisticsStatType ?? this.statisticsStatType,
      statisticsTimeRange: statisticsTimeRange ?? this.statisticsTimeRange,
      theme: theme ?? this.theme,
      themeCustomColor: themeCustomColor ?? this.themeCustomColor,
      themeEnhancement: themeEnhancement ?? this.themeEnhancement,
      themeUseSystemColor: themeUseSystemColor ?? this.themeUseSystemColor,
      useAtkinsonHyperlegible: useAtkinsonHyperlegible ?? this.useAtkinsonHyperlegible,
      usersSort: usersSort ?? this.usersSort,
      wizardComplete: wizardComplete ?? this.wizardComplete,
    );
  }

  Map<String, String> dump() {
    return {
      'Active Server': '${activeServer.plexName} (${activeServer.id})',
      'App Update Available': appUpdateAvailable.toString(),
      'Disable Image Backgrounds': disableImageBackgrounds.toString(),
      'Double Back To Exit': doubleBackToExit.toString(),
      'Graph Time Range': graphTimeRange.toString(),
      'Graph Tips Shown': graphTipsShown.toString(),
      'Graph Y Axis': graphYAxis.toString(),
      'History Filter': historyFilter.toString(),
      'Home Page': homePage,
      'Libraries Sort': librariesSort.toString(),
      'Library Media Full Refresh': libraryMediaFullRefresh.toString(),
      'Mask Sensitive Info': maskSensitiveInfo.toString(),
      'Multiserver Activity': multiserverActivity.toString(),
      'OneSignal Banner Dismissed': oneSignalBannerDismissed.toString(),
      'OneSignal Privacy Accepted': oneSignalConsented.toString(),
      'Patch': patch.toString(),
      'Recently Added Filter': recentlyAddedFilter,
      'Refresh Rate': refreshRate.toString(),
      'Server Timeout': serverTimeout.toString(),
      'Statistics Stat Type': statisticsStatType.toString(),
      'Statistics Time Range': statisticsTimeRange.toString(),
      'Theme': theme.themeName(),
      'Theme Custom Color': themeCustomColor.toString(),
      'Theme Enhancement': themeEnhancement.name(),
      'Theme Use System Color': themeUseSystemColor.toString(),
      'Use Atkinson Hyperlegible Font': useAtkinsonHyperlegible.toString(),
      'Users Sort': usersSort,
      'Wizard Complete': wizardComplete.toString(),
    };
  }

  @override
  List<Object> get props => [
        activeServer,
        appUpdateAvailable,
        disableImageBackgrounds,
        doubleBackToExit,
        graphTimeRange,
        graphTipsShown,
        graphYAxis,
        historyFilter,
        homePage,
        librariesSort,
        libraryMediaFullRefresh,
        maskSensitiveInfo,
        multiserverActivity,
        oneSignalBannerDismissed,
        oneSignalConsented,
        recentlyAddedFilter,
        refreshRate,
        secret,
        serverTimeout,
        statisticsStatType,
        statisticsTimeRange,
        theme,
        themeCustomColor,
        themeEnhancement,
        themeUseSystemColor,
        useAtkinsonHyperlegible,
        usersSort,
        wizardComplete,
      ];
}
