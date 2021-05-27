part of 'wizard_bloc.dart';

abstract class WizardState extends Equatable {
  const WizardState();

  @override
  List<Object> get props => [];
}

class WizardInitial extends WizardState {}

class WizardLoaded extends WizardState {
  final WizardStage wizardStage;
  final bool gettingStartedAccepted;
  final bool onesignalAccepted;

  WizardLoaded({
    @required this.wizardStage,
    this.gettingStartedAccepted = false,
    this.onesignalAccepted = false,
  });

  WizardLoaded copyWith({
    WizardStage wizardStage,
    bool gettingStartedAccepted,
    bool onesignalAccepted,
  }) {
    return WizardLoaded(
      wizardStage: wizardStage ?? this.wizardStage,
      gettingStartedAccepted:
          gettingStartedAccepted ?? this.gettingStartedAccepted,
      onesignalAccepted: onesignalAccepted ?? this.onesignalAccepted,
    );
  }

  @override
  List<Object> get props => [
        wizardStage,
        gettingStartedAccepted,
        onesignalAccepted,
      ];
}
