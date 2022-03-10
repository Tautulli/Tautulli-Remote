import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';

abstract class AppSettings extends Equatable {
  final ServerModel activeServer;
  final bool doubleTapToExit;
  final bool maskSensitiveInfo;
  final bool oneSignalBannerDismissed;
  final bool oneSignalConsented;
  final int refreshRate;
  final int serverTimeout;

  const AppSettings({
    required this.activeServer,
    required this.doubleTapToExit,
    required this.maskSensitiveInfo,
    required this.oneSignalBannerDismissed,
    required this.oneSignalConsented,
    required this.refreshRate,
    required this.serverTimeout,
  });

  @override
  List<Object> get props => [
        activeServer,
        doubleTapToExit,
        maskSensitiveInfo,
        oneSignalBannerDismissed,
        oneSignalConsented,
        refreshRate,
        serverTimeout,
      ];
}
