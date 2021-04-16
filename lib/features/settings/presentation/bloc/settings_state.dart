part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoadInProgress extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoadSuccess extends SettingsState {
  final List<ServerModel> serverList;
  final int serverTimeout;
  final int refreshRate;
  final bool doubleTapToExit;
  final bool maskSensitiveInfo;
  final String lastSelectedServer;
  final String statsType;
  final String yAxis;
  final String usersSort;
  final bool oneSignalBannerDismissed;
  final String sortChanged;

  SettingsLoadSuccess({
    @required this.serverList,
    @required this.serverTimeout,
    @required this.refreshRate,
    @required this.doubleTapToExit,
    @required this.maskSensitiveInfo,
    @required this.lastSelectedServer,
    @required this.statsType,
    @required this.yAxis,
    @required this.usersSort,
    @required this.oneSignalBannerDismissed,
    this.sortChanged,
  });

  SettingsLoadSuccess copyWith({
    List<ServerModel> serverList,
    int serverTimeout,
    int refreshRate,
    bool doubleTapToExit,
    bool maskSensitiveInfo,
    String lastSelectedServer,
    String statsType,
    String yAxis,
    String usersSort,
    bool oneSignalBannerDismissed,
    String sortChanged,
  }) {
    return SettingsLoadSuccess(
      serverList: serverList ?? this.serverList,
      serverTimeout: serverTimeout ?? this.serverTimeout,
      refreshRate: refreshRate ?? this.refreshRate,
      doubleTapToExit: doubleTapToExit ?? this.doubleTapToExit,
      maskSensitiveInfo: maskSensitiveInfo ?? this.maskSensitiveInfo,
      lastSelectedServer: lastSelectedServer ?? this.lastSelectedServer,
      statsType: statsType ?? this.statsType,
      yAxis: yAxis ?? this.yAxis,
      usersSort: usersSort ?? this.usersSort,
      oneSignalBannerDismissed:
          oneSignalBannerDismissed ?? this.oneSignalBannerDismissed,
      sortChanged: sortChanged ?? this.sortChanged,
    );
  }

  @override
  List<Object> get props => [
        serverList,
        serverTimeout,
        refreshRate,
        doubleTapToExit,
        maskSensitiveInfo,
        lastSelectedServer,
        statsType,
        yAxis,
        usersSort,
        oneSignalBannerDismissed,
        sortChanged,
      ];
}
