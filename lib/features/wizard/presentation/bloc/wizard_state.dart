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
  final bool oneSignalSubscribed;

  WizardLoaded({
    @required this.wizardStage,
    this.gettingStartedAccepted = false,
    this.oneSignalSubscribed = false,
  });

  WizardLoaded copyWith({
    WizardStage wizardStage,
    bool gettingStartedAccepted,
    bool oneSignalSubscribed,
  }) {
    return WizardLoaded(
      wizardStage: wizardStage ?? this.wizardStage,
      gettingStartedAccepted:
          gettingStartedAccepted ?? this.gettingStartedAccepted,
      oneSignalSubscribed: oneSignalSubscribed ?? this.oneSignalSubscribed,
    );
  }

  @override
  List<Object> get props => [
        wizardStage,
        gettingStartedAccepted,
        oneSignalSubscribed,
      ];
}
