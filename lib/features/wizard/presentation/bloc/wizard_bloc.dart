import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';

part 'wizard_event.dart';
part 'wizard_state.dart';

enum WizardStage {
  gettingStarted,
  oneSignal,
  servers,
  closing,
}

WizardStage currentWizardStage = WizardStage.gettingStarted;

class WizardBloc extends Bloc<WizardEvent, WizardState> {
  WizardBloc()
      : super(
          WizardLoaded(
            wizardStage: WizardStage.gettingStarted,
          ),
        );

  @override
  Stream<WizardState> mapEventToState(
    WizardEvent event,
  ) async* {
    final currentState = state;

    if (currentState is WizardLoaded) {
      if (event is WizardUpdateStage) {
        currentWizardStage = _UpdateStage(event.currentStage);
        yield currentState.copyWith(
          wizardStage: currentWizardStage,
        );
      }
      if (event is WizardAcceptGettingStarted) {
        yield currentState.copyWith(
          gettingStartedAccepted: event.accept,
        );
      }
      if (event is WizardOneSignalSubscribed) {
        yield currentState.copyWith(
          oneSignalSubscribed: event.oneSignalSubscribed,
        );
      }
    }
  }
}

WizardStage _UpdateStage(WizardStage currentStage) {
  switch (currentStage) {
    case (WizardStage.gettingStarted):
      return WizardStage.oneSignal;
    case (WizardStage.oneSignal):
      return WizardStage.servers;
    case (WizardStage.servers):
      return WizardStage.closing;
    case (WizardStage.closing):
      return WizardStage.gettingStarted;
    default:
      return WizardStage.closing;
  }
}
