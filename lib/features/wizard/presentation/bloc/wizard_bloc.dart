import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'wizard_event.dart';
part 'wizard_state.dart';

class WizardBloc extends Bloc<WizardEvent, WizardState> {
  WizardBloc()
      : super(
          const WizardInitial(
            activeStep: 0,
            oneSignalAllowed: false,
            oneSignalSkipped: false,
            stepCount: 5,
            serversSkipped: false,
          ),
        ) {
    on<WizardNext>((event, emit) => _onWizardNext(event, emit));
    on<WizardPrevious>((event, emit) => _onWizardPrevious(event, emit));
    on<WizardSkipOneSignal>(
      (event, emit) => _onWizardSkipOneSignal(event, emit),
    );
    on<WizardSkipServers>(
      (event, emit) => _onWizardSkipServers(event, emit),
    );
    on<WizardToggleOneSignal>(
      (event, emit) => _onWizardToggleOneSignal(event, emit),
    );
  }

  _onWizardNext(
    WizardNext event,
    Emitter<WizardState> emit,
  ) {
    final currentState = state as WizardInitial;

    if (currentState.activeStep < currentState.stepCount - 1) {
      emit(
        currentState.copyWith(activeStep: currentState.activeStep + 1),
      );
    }
  }

  _onWizardPrevious(
    WizardPrevious event,
    Emitter<WizardState> emit,
  ) {
    final currentState = state as WizardInitial;

    if (currentState.activeStep > 0) {
      emit(
        currentState.copyWith(activeStep: currentState.activeStep - 1),
      );
    }
  }

  _onWizardSkipOneSignal(
    WizardSkipOneSignal event,
    Emitter<WizardState> emit,
  ) {
    final currentState = state as WizardInitial;

    emit(
      currentState.copyWith(
        activeStep: currentState.activeStep + 1,
        oneSignalSkipped: true,
      ),
    );
  }

  _onWizardSkipServers(
    WizardSkipServers event,
    Emitter<WizardState> emit,
  ) {
    final currentState = state as WizardInitial;

    emit(
      currentState.copyWith(
        activeStep: currentState.activeStep + 1,
        serversSkipped: true,
      ),
    );
  }

  _onWizardToggleOneSignal(
    WizardToggleOneSignal event,
    Emitter<WizardState> emit,
  ) {
    final currentState = state as WizardInitial;

    emit(
      currentState.copyWith(oneSignalAllowed: !currentState.oneSignalAllowed),
    );
  }
}
