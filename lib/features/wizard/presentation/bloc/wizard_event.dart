// @dart=2.9

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

class WizardAcceptOneSignal extends WizardEvent {
  final bool accept;

  WizardAcceptOneSignal(this.accept);

  @override
  List<Object> get props => [accept];
}

// class WizardRejectOneSignalPermission extends WizardEvent {}

// class WizardUpdateIosAppTrackingPermission extends WizardEvent {}

// class WizardUpdateIosNotificationPermission extends WizardEvent {}
