part of 'wizard_bloc.dart';

abstract class WizardState extends Equatable {
  const WizardState();

  @override
  List<Object> get props => [];
}

class WizardLoaded extends WizardState {
  final WizardStage wizardStage;
  final bool onesignalAccepted;

  WizardLoaded({
    @required this.wizardStage,
    this.onesignalAccepted = false,
  });

  WizardLoaded copyWith({
    WizardStage wizardStage,
    bool gettingStartedAccepted,
    bool onesignalAccepted,
  }) {
    return WizardLoaded(
      wizardStage: wizardStage ?? this.wizardStage,
      onesignalAccepted: onesignalAccepted ?? this.onesignalAccepted,
    );
  }

  @override
  List<Object> get props => [
        wizardStage,
        onesignalAccepted,
      ];
}
