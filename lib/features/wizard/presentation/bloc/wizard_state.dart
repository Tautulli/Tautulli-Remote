part of 'wizard_bloc.dart';

abstract class WizardState extends Equatable {
  const WizardState();

  @override
  List<Object> get props => [];
}

class WizardLoaded extends WizardState {
  final WizardStage wizardStage;
  final bool onesignalAccepted;
  final bool onesignalPermissionRejected;

  WizardLoaded({
    @required this.wizardStage,
    this.onesignalAccepted = false,
    this.onesignalPermissionRejected = false,
  });

  WizardLoaded copyWith({
    WizardStage wizardStage,
    bool gettingStartedAccepted,
    bool onesignalAccepted,
    bool onesignalPermissionRejected,
  }) {
    return WizardLoaded(
      wizardStage: wizardStage ?? this.wizardStage,
      onesignalAccepted: onesignalAccepted ?? this.onesignalAccepted,
      onesignalPermissionRejected:
          onesignalPermissionRejected ?? this.onesignalPermissionRejected,
    );
  }

  @override
  List<Object> get props => [
        wizardStage,
        onesignalAccepted,
        onesignalPermissionRejected,
      ];
}
