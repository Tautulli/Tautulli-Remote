part of 'wizard_bloc.dart';

abstract class WizardEvent extends Equatable {
  const WizardEvent();

  @override
  List<Object> get props => [];
}

class WizardUpdateStage extends WizardEvent {
  final WizardStage currentStage;
  final OneSignalSubscriptionState oneSignalSubscriptionState;

  WizardUpdateStage(
    this.currentStage, {
    this.oneSignalSubscriptionState,
  });

  @override
  List<Object> get props => [currentStage, oneSignalSubscriptionState];
}

class WizardAcceptGettingStarted extends WizardEvent {
  final bool accept;

  WizardAcceptGettingStarted(this.accept);

  @override
  List<Object> get props => [accept];
}

class WizardOneSignalSubscribed extends WizardEvent {
  final bool oneSignalSubscribed;

  WizardOneSignalSubscribed(
    this.oneSignalSubscribed,
  );

  @override
  List<Object> get props => [oneSignalSubscribed];
}
