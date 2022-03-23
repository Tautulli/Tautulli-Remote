part of 'wizard_bloc.dart';

abstract class WizardEvent extends Equatable {
  const WizardEvent();

  @override
  List<Object> get props => [];
}

class WizardNext extends WizardEvent {}

class WizardPrevious extends WizardEvent {}

class WizardSkipOneSignal extends WizardEvent {}

class WizardSkipServers extends WizardEvent {}

class WizardToggleOneSignal extends WizardEvent {}
