import 'package:equatable/equatable.dart';

abstract class AppSettings extends Equatable {
  final bool doubleTapToExit;
  final bool maskSensitiveInfo;
  final bool oneSignalBannerDismissed;
  final bool oneSignalConsented;
  final int refreshRate;
  final int serverTimeout;

  const AppSettings({
    required this.doubleTapToExit,
    required this.maskSensitiveInfo,
    required this.oneSignalBannerDismissed,
    required this.oneSignalConsented,
    required this.refreshRate,
    required this.serverTimeout,
  });

  @override
  List<Object> get props => [
        doubleTapToExit,
        maskSensitiveInfo,
        oneSignalBannerDismissed,
        oneSignalConsented,
        refreshRate,
        serverTimeout,
      ];
}
