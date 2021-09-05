// @dart=2.9

part of 'wizard_bloc.dart';

abstract class WizardState extends Equatable {
  const WizardState();

  @override
  List<Object> get props => [];
}

class WizardLoaded extends WizardState {
  final WizardStage wizardStage;
  final bool onesignalAccepted;
  // final bool onesignalPermissionRejected;
  // final bool iosAppTrackingPermission;
  // final bool iosNotificationPermission;

  WizardLoaded({
    @required this.wizardStage,
    this.onesignalAccepted = false,
    // this.onesignalPermissionRejected = false,
    // this.iosAppTrackingPermission = false,
    // this.iosNotificationPermission = false,
  });

  WizardLoaded copyWith({
    WizardStage wizardStage,
    bool gettingStartedAccepted,
    bool onesignalAccepted,
    // bool onesignalPermissionRejected,
    // bool iosAppTrackingPermission,
    // bool iosNotificationPermission,
  }) {
    return WizardLoaded(
      wizardStage: wizardStage ?? this.wizardStage,
      onesignalAccepted: onesignalAccepted ?? this.onesignalAccepted,
      // onesignalPermissionRejected:
      //     onesignalPermissionRejected ?? this.onesignalPermissionRejected,
      // iosAppTrackingPermission:
      //     iosAppTrackingPermission ?? this.iosAppTrackingPermission,
      // iosNotificationPermission:
      //     iosNotificationPermission ?? this.iosNotificationPermission,
    );
  }

  @override
  List<Object> get props => [
        wizardStage,
        onesignalAccepted,
        // onesignalPermissionRejected,
        // iosAppTrackingPermission,
        // iosNotificationPermission,
      ];
}
