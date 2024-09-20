part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsAddServer extends SettingsEvent {
  final String primaryConnectionAddress;
  final String? secondaryConnectionAddress;
  final String deviceToken;
  final String tautulliId;
  final String plexName;
  final String plexIdentifier;
  final bool plexPass;
  final bool oneSignalRegistered;
  final List<CustomHeaderModel>? customHeaders;

  const SettingsAddServer({
    required this.primaryConnectionAddress,
    this.secondaryConnectionAddress,
    required this.deviceToken,
    required this.tautulliId,
    required this.plexName,
    required this.plexIdentifier,
    required this.plexPass,
    required this.oneSignalRegistered,
    this.customHeaders,
  });

  @override
  List<Object> get props => [
        primaryConnectionAddress,
        deviceToken,
        tautulliId,
        plexName,
        plexPass,
        oneSignalRegistered,
      ];
}

class SettingsClearCache extends SettingsEvent {}

class SettingsDeleteCustomHeader extends SettingsEvent {
  final String tautulliId;
  final String title;

  const SettingsDeleteCustomHeader({
    required this.tautulliId,
    required this.title,
  });

  @override
  List<Object> get props => [tautulliId, title];
}

class SettingsDeleteServer extends SettingsEvent {
  final int id;
  final String plexName;

  const SettingsDeleteServer({
    required this.id,
    required this.plexName,
  });

  @override
  List<Object> get props => [id, plexName];
}

class SettingsLoad extends SettingsEvent {
  final bool updateServerInfo;

  const SettingsLoad({
    this.updateServerInfo = true,
  });

  @override
  List<Object> get props => [updateServerInfo];
}

class SettingsUpdateActiveServer extends SettingsEvent {
  final ServerModel activeServer;

  const SettingsUpdateActiveServer({
    required this.activeServer,
  });

  @override
  List<Object> get props => [activeServer];
}

class SettingsUpdateAppUpdateAvailable extends SettingsEvent {
  final bool appUpdateAvailable;

  const SettingsUpdateAppUpdateAvailable({
    required this.appUpdateAvailable,
  });

  @override
  List<Object> get props => [appUpdateAvailable];
}

class SettingsUpdateConnectionInfo extends SettingsEvent {
  final bool primary;
  final String connectionAddress;
  final ServerModel server;

  const SettingsUpdateConnectionInfo({
    required this.primary,
    required this.connectionAddress,
    required this.server,
  });

  @override
  List<Object> get props => [primary, connectionAddress, server];
}

class SettingsUpdateCustomHeaders extends SettingsEvent {
  final String tautulliId;
  final String title;
  final String subtitle;
  final bool basicAuth;
  final String? previousTitle;

  const SettingsUpdateCustomHeaders({
    required this.tautulliId,
    required this.title,
    required this.subtitle,
    required this.basicAuth,
    this.previousTitle,
  });

  @override
  List<Object> get props => [tautulliId, title, subtitle, basicAuth];
}

class SettingsUpdateDisableImageBackgrounds extends SettingsEvent {
  final bool disableImageBackgrounds;

  const SettingsUpdateDisableImageBackgrounds(this.disableImageBackgrounds);

  @override
  List<Object> get props => [disableImageBackgrounds];
}

class SettingsUpdateDoubleBackToExit extends SettingsEvent {
  final bool doubleBackToExit;

  const SettingsUpdateDoubleBackToExit(this.doubleBackToExit);

  @override
  List<Object> get props => [doubleBackToExit];
}

class SettingsUpdateGraphTimeRange extends SettingsEvent {
  final int graphTimeRange;

  const SettingsUpdateGraphTimeRange(this.graphTimeRange);

  @override
  List<Object> get props => [graphTimeRange];
}

class SettingsUpdateGraphTipsShown extends SettingsEvent {
  final bool graphTipsShown;

  const SettingsUpdateGraphTipsShown(this.graphTipsShown);

  @override
  List<Object> get props => [graphTipsShown];
}

class SettingsUpdateGraphYAxis extends SettingsEvent {
  final PlayMetricType graphYAxis;

  const SettingsUpdateGraphYAxis(this.graphYAxis);

  @override
  List<Object> get props => [graphYAxis];
}

class SettingsUpdateHistoryFilter extends SettingsEvent {
  final Map<String, bool> map;

  const SettingsUpdateHistoryFilter(this.map);

  @override
  List<Object> get props => [map];
}

class SettingsUpdateHomePage extends SettingsEvent {
  final String homePage;

  const SettingsUpdateHomePage(this.homePage);

  @override
  List<Object> get props => [homePage];
}

class SettingsUpdateLibrariesSort extends SettingsEvent {
  final String librariesSort;

  const SettingsUpdateLibrariesSort(this.librariesSort);

  @override
  List<Object> get props => [librariesSort];
}

class SettingsUpdateLibraryMediaFullRefresh extends SettingsEvent {
  final bool libraryMediaFullRefresh;

  const SettingsUpdateLibraryMediaFullRefresh(this.libraryMediaFullRefresh);

  @override
  List<Object> get props => [libraryMediaFullRefresh];
}

class SettingsUpdateMaskSensitiveInfo extends SettingsEvent {
  final bool maskSensitiveInfo;

  const SettingsUpdateMaskSensitiveInfo(this.maskSensitiveInfo);

  @override
  List<Object> get props => [maskSensitiveInfo];
}

class SettingsUpdateMultiserverActivity extends SettingsEvent {
  final bool multiserverActivity;

  const SettingsUpdateMultiserverActivity(this.multiserverActivity);

  @override
  List<Object> get props => [multiserverActivity];
}

class SettingsUpdateOneSignalBannerDismiss extends SettingsEvent {
  final bool dismiss;

  const SettingsUpdateOneSignalBannerDismiss(this.dismiss);

  @override
  List<Object> get props => [dismiss];
}

class SettingsUpdateOneSignalConsented extends SettingsEvent {
  final bool consented;

  const SettingsUpdateOneSignalConsented(this.consented);

  @override
  List<Object> get props => [consented];
}

class SettingsUpdatePrimaryActive extends SettingsEvent {
  final String tautulliId;
  final bool primaryActive;

  const SettingsUpdatePrimaryActive({
    required this.tautulliId,
    required this.primaryActive,
  });

  @override
  List<Object> get props => [tautulliId, primaryActive];
}

class SettingsUpdateRecentlyAddedFilter extends SettingsEvent {
  final String recentlyAddedFilter;

  const SettingsUpdateRecentlyAddedFilter(this.recentlyAddedFilter);

  @override
  List<Object> get props => [recentlyAddedFilter];
}

class SettingsUpdateRefreshRate extends SettingsEvent {
  final int refreshRate;

  const SettingsUpdateRefreshRate(this.refreshRate);

  @override
  List<Object> get props => [refreshRate];
}

class SettingsUpdateSecret extends SettingsEvent {
  final bool secret;

  const SettingsUpdateSecret(this.secret);

  @override
  List<Object> get props => [secret];
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
  final String? dateFormat;
  final String? timeFormat;
  final bool oneSignalRegistered;
  final List<CustomHeaderModel>? customHeaders;

  const SettingsUpdateServer({
    required this.id,
    required this.sortIndex,
    required this.primaryConnectionAddress,
    required this.secondaryConnectionAddress,
    required this.deviceToken,
    required this.tautulliId,
    required this.plexName,
    required this.plexIdentifier,
    required this.plexPass,
    this.dateFormat,
    this.timeFormat,
    required this.oneSignalRegistered,
    this.customHeaders,
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
        oneSignalRegistered,
      ];
}

class SettingsUpdateServerPlexAndTautulliInfo extends SettingsEvent {
  final ServerModel serverModel;

  const SettingsUpdateServerPlexAndTautulliInfo({
    required this.serverModel,
  });

  @override
  List<Object> get props => [serverModel];
}

class SettingsUpdateServerSort extends SettingsEvent {
  final int serverId;
  final int oldIndex;
  final int newIndex;

  const SettingsUpdateServerSort({
    required this.serverId,
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object> get props => [serverId, oldIndex, newIndex];
}

class SettingsUpdateServerTimeout extends SettingsEvent {
  final int timeout;

  const SettingsUpdateServerTimeout(this.timeout);

  @override
  List<Object> get props => [timeout];
}

class SettingsUpdateStatisticsStatType extends SettingsEvent {
  final PlayMetricType statisticsStatType;

  const SettingsUpdateStatisticsStatType(this.statisticsStatType);

  @override
  List<Object> get props => [statisticsStatType];
}

class SettingsUpdateStatisticsTimeRange extends SettingsEvent {
  final int statisticsTimeRange;

  const SettingsUpdateStatisticsTimeRange(this.statisticsTimeRange);

  @override
  List<Object> get props => [statisticsTimeRange];
}

class SettingsUpdateTheme extends SettingsEvent {
  final ThemeType themeType;

  const SettingsUpdateTheme(this.themeType);

  @override
  List<Object> get props => [themeType];
}

class SettingsUpdateThemeCustomColor extends SettingsEvent {
  final Color color;

  const SettingsUpdateThemeCustomColor(this.color);

  @override
  List<Object> get props => [color];
}

class SettingsUpdateThemeEnhancement extends SettingsEvent {
  final ThemeEnhancementType themeEnhancementType;

  const SettingsUpdateThemeEnhancement(this.themeEnhancementType);

  @override
  List<Object> get props => [themeEnhancementType];
}

class SettingsUpdateThemeUseSystemColor extends SettingsEvent {
  final bool useSystemColor;

  const SettingsUpdateThemeUseSystemColor(this.useSystemColor);

  @override
  List<Object> get props => [useSystemColor];
}

class SettingsUpdateUseAtkinsonHyperlegible extends SettingsEvent {
  final bool useAtkinsonHyperlegible;

  const SettingsUpdateUseAtkinsonHyperlegible(this.useAtkinsonHyperlegible);

  @override
  List<Object> get props => [useAtkinsonHyperlegible];
}

class SettingsUpdateUsersSort extends SettingsEvent {
  final String usersSort;

  const SettingsUpdateUsersSort(this.usersSort);

  @override
  List<Object> get props => [usersSort];
}

class SettingsUpdateWizardComplete extends SettingsEvent {
  final bool wizardComplete;

  const SettingsUpdateWizardComplete(this.wizardComplete);

  @override
  List<Object> get props => [wizardComplete];
}
